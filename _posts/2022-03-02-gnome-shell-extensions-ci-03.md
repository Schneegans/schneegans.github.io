---
layout: post
title: "GNOME Shell Extensions & CI: Part III"
category: tutorials
teaser: "ci3.jpg"
colors: "color-ci3"
license: "public domain"
tagline: "Testing your code is important."
tags: ["tutorial"]
---

In the last part of the series, I explain how I set up continuous integration tests using [podman](https://podman.io/) and [GitHub Actions](https://github.com/features/actions).

<!--more-->

If you haven't read the first parts yet, I would suggest doing this before.
Here are links to the other parts:

1. [Bundling the Extension]({% post_url 2022-02-28-gnome-shell-extensions-ci-01 %})
2. [Automated Release Publishing]({% post_url 2022-03-01-gnome-shell-extensions-ci-02 %})
3. Automated Tests with GitHub Actions (this post)

## GNOME Shell in a Container

<div class="link-color-background well">
💞 At this point, I want to send a big THANKS to GitHub user <a href="https://github.com/amezin">@amezin</a> who helped me a lot in setting up these containers!
</div>

So the idea is to run GNOME Shell in a container, install the extension, and perform various tests on it.
For this purpose, I created several Fedora-based containers, one for each GNOME Shell version I want to run tests on.
These containers are currently available:
* **[ghcr.io/schneegans/gnome-shell-pod-32](https://github.com/Schneegans/gnome-shell-pod/pkgs/container/gnome-shell-pod-32)**: GNOME Shell 3.36 (based on Fedora 32)
* **[ghcr.io/schneegans/gnome-shell-pod-33](https://github.com/Schneegans/gnome-shell-pod/pkgs/container/gnome-shell-pod-33)**: GNOME Shell 3.38 (based on Fedora 33)
* **[ghcr.io/schneegans/gnome-shell-pod-34](https://github.com/Schneegans/gnome-shell-pod/pkgs/container/gnome-shell-pod-34)**: GNOME Shell 40 (based on Fedora 34)
* **[ghcr.io/schneegans/gnome-shell-pod-35](https://github.com/Schneegans/gnome-shell-pod/pkgs/container/gnome-shell-pod-35)**: GNOME Shell 41 (based on Fedora 35)
* **[ghcr.io/schneegans/gnome-shell-pod-36](https://github.com/Schneegans/gnome-shell-pod/pkgs/container/gnome-shell-pod-36)**: GNOME Shell 42 (based on Fedora 36)
* **[ghcr.io/schneegans/gnome-shell-pod-37](https://github.com/Schneegans/gnome-shell-pod/pkgs/container/gnome-shell-pod-37)**: GNOME Shell 43 (based on Fedora 36)

<div class="link-color-background well">
📦 For more information on the content of those container images, please visit the <a href="https://github.com/Schneegans/gnome-shell-pod">repository with the deployed packages on GitHub</a>.
</div>

So here's an example what you can do with these containers (you will need to have `podman` and `imagemagick` installed).
Run the following commands one by one.
The first command will download and run a container based on Fedora 33.
You can then use the two other commands to run GNOME Shell, and open the `gnome-control-center` inside the container.


{% highlight bash linenos %}
# Run the container in interactive mode.
podman run --rm --cap-add=SYS_NICE --cap-add=IPC_LOCK \
            -ti ghcr.io/schneegans/gnome-shell-pod-33

# Now do this inside the container to start GNOME Shell.
systemctl --user start "gnome-xsession@:99"

# For example, you can now run this command.
DISPLAY=:99 gnome-control-center
{% endhighlight %}

Did it work?
Well, we will see!
Open up another terminal on your host and execute the following commands.
These will capture a screenshot of GNOME Shell inside the container!

{% highlight bash linenos %}
# Copy the framebuffer of xvfb.
podman cp $(podman ps -q -n 1):/opt/Xvfb_screen0 .

# Convert it to jpeg (this step requires imagemagick).
convert xwd:Xvfb_screen0 capture.jpg

# And finally display the image.
# This way we can see that GNOME Shell is actually up and running!
eog capture.jpg
{% endhighlight %}

{% assign picture = "podman-capture-1.jpg" %}
{% assign text = "GNOME Shell running in a container." %}
{% include image.html %}

To shut down the container, hit Ctrl+C to kill the GNOME control center and execute `poweroff` to exit the container.

I think you see where this is going.
In the next example, we will perform the same steps, but with a non-interactive container.
You can copy-paste the entire block below to your terminal and execute it all together.

{% highlight bash linenos %}
# Run the container in detached mode.
POD=$(podman run --rm --cap-add=SYS_NICE --cap-add=IPC_LOCK \
                  -td ghcr.io/schneegans/gnome-shell-pod-33)

# This method is used to run arbitrary commands inside the running container.
# The set-env.sh script is contained in the container image and sets all
# environment variables required to interact with the D-Bus.
# You can look at the script here:
# https://github.com/Schneegans/gnome-shell-pod/tree/master/bin
do_in_pod() {
  podman exec --user gnomeshell --workdir /home/gnomeshell \
              "${POD}" set-env.sh "$@"
}

# Wait until the user bus is available. This is also a custom script
# contained in the container.
do_in_pod wait-user-bus.sh 

# Start GNOME Shell.
do_in_pod systemctl --user start "gnome-xsession@:99"

# Wait some time until GNOME Shell has been started.
sleep 3

# Run the application.
do_in_pod gnome-control-center &

# Wait another few seconds.
sleep 3

# Now make a screenshot and show it!
podman cp ${POD}:/opt/Xvfb_screen0 . && \
       convert xwd:Xvfb_screen0 capture.jpg && \
       eog capture.jpg

# Now we can stop the container again.
podman stop ${POD}
{% endhighlight %}

Feel free to replace the `gnome-shell-pod-33` with any other container image name. For example, `gnome-shell-pod-36` will give you GNOME Shell 42 (we will have to disable this welcome tour later...):

{% assign picture = "podman-capture-2.jpg" %}
{% assign text = "GNOME Shell 42 running in a container." %}
{% include image.html %}


## Executing Tests in the Container

We can now use this setup to run automated tests inside the containers.
First, you want to copy your extension zip into the container (`podman cp`).
Then you install and enable your extension with `gnome-extensions install` and `gnome-extensions enable` respectively.
Thereafter, launch GNOME Shell and closes the initial overview & welcome tour of GNOME 40+.
Finally, you can for instance open the settings dialog, take a screenshot and look for its presence!
An example of this is the [test script of the Desktop Cube](https://github.com/Schneegans/Desktop-Cube/blob/main/tests/run-test.sh) extensions.

This is just a minimal example for how such a testing script could look like.
Of course, you can do this completely differently!
You could also add a test API to your extension which you call from the script.
There are many other things which could be done and with a bit of creativity.
For example, the [test script of Fly-Pie](https://github.com/Schneegans/Fly-Pie/blob/main/tests/run-test.sh) uses `xdotool` to move the mouse pointer and to click on menu items.

### A more Complex Example: Burn-My-Windows

To test the animations of the [Burn-My-Windows](https://github.com/Schneegans/Burn-My-Windows) extensions, I added a `test-mode` boolean setting which can be enabled using `gsettings set` during the tests.
This causes all animations to just show one fixed frame for a period of five seconds (this ensures that all screenshots will capture the same moment of the animations).
Furthermore, it makes sure that all calls to `Math.random()` are effectively disabled.

Then, I created a [script](https://github.com/Schneegans/Burn-My-Windows/blob/main/tests/generate-references.sh) which generates [reference images](https://github.com/Schneegans/Burn-My-Windows/tree/main/tests/references) for all supported GNOME versions / X11 / Wayland / all window-open animations / all window-close animations.
This makes up for a total of 200+ test cases.
Below, you can see the reference images for some included effects.
You can observe, how they slightly differ from configuration to configuration.

The [test script](https://github.com/Schneegans/Burn-My-Windows/blob/main/tests/run-test.sh) of Burn-My-Windows then re-captures all those images and compares them with the reference versions.

|  | Energ. A | Energ. B | Fire | Portal | Hexagon
|--|--|--|--|--|
GNOME 3.36, Wayland, Open |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-open-gnome-wayland-nested-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-open-gnome-wayland-nested-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-open-gnome-wayland-nested-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-open-gnome-wayland-nested-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-open-gnome-wayland-nested-32.png" />|
GNOME 3.36, Wayland, Close |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-close-gnome-wayland-nested-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-close-gnome-wayland-nested-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-close-gnome-wayland-nested-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-close-gnome-wayland-nested-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-close-gnome-wayland-nested-32.png" />|
GNOME 3.36, X11, Open |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-open-gnome-xsession-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-open-gnome-xsession-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-open-gnome-xsession-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-open-gnome-xsession-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-open-gnome-xsession-32.png" />|
GNOME 3.36, X11, Close |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-close-gnome-xsession-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-close-gnome-xsession-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-close-gnome-xsession-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-close-gnome-xsession-32.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-close-gnome-xsession-32.png" />|
GNOME 3.38, Wayland, Open |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-open-gnome-wayland-nested-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-open-gnome-wayland-nested-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-open-gnome-wayland-nested-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-open-gnome-wayland-nested-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-open-gnome-wayland-nested-33.png" />|
GNOME 3.38, Wayland, Close |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-close-gnome-wayland-nested-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-close-gnome-wayland-nested-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-close-gnome-wayland-nested-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-close-gnome-wayland-nested-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-close-gnome-wayland-nested-33.png" />|
GNOME 3.38, X11, Open |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-open-gnome-xsession-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-open-gnome-xsession-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-open-gnome-xsession-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-open-gnome-xsession-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-open-gnome-xsession-33.png" />|
GNOME 3.38, X11, Close |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-close-gnome-xsession-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-close-gnome-xsession-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-close-gnome-xsession-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-close-gnome-xsession-33.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-close-gnome-xsession-33.png" />|
GNOME 40, Wayland, Open |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-open-gnome-wayland-nested-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-open-gnome-wayland-nested-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-open-gnome-wayland-nested-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-open-gnome-wayland-nested-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-open-gnome-wayland-nested-34.png" />|
GNOME 40, Wayland, Close |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-close-gnome-wayland-nested-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-close-gnome-wayland-nested-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-close-gnome-wayland-nested-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-close-gnome-wayland-nested-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-close-gnome-wayland-nested-34.png" />|
GNOME 40, X11, Open |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-open-gnome-xsession-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-open-gnome-xsession-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-open-gnome-xsession-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-open-gnome-xsession-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-open-gnome-xsession-34.png" />|
GNOME 40, X11, Close |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-close-gnome-xsession-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-close-gnome-xsession-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-close-gnome-xsession-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-close-gnome-xsession-34.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-close-gnome-xsession-34.png" />|
GNOME 41, Wayland, Open |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-open-gnome-wayland-nested-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-open-gnome-wayland-nested-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-open-gnome-wayland-nested-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-open-gnome-wayland-nested-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-open-gnome-wayland-nested-35.png" />|
GNOME 41, Wayland, Close |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-close-gnome-wayland-nested-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-close-gnome-wayland-nested-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-close-gnome-wayland-nested-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-close-gnome-wayland-nested-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-close-gnome-wayland-nested-35.png" />|
GNOME 41, X11, Open |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-open-gnome-xsession-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-open-gnome-xsession-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-open-gnome-xsession-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-open-gnome-xsession-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-open-gnome-xsession-35.png" />|
GNOME 41, X11, Close |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-close-gnome-xsession-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-close-gnome-xsession-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-close-gnome-xsession-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-close-gnome-xsession-35.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-close-gnome-xsession-35.png" />|
GNOME 42, Wayland, Open |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-open-gnome-wayland-nested-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-open-gnome-wayland-nested-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-open-gnome-wayland-nested-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-open-gnome-wayland-nested-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-open-gnome-wayland-nested-36.png" />|
GNOME 42, Wayland, Close |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-close-gnome-wayland-nested-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-close-gnome-wayland-nested-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-close-gnome-wayland-nested-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-close-gnome-wayland-nested-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-close-gnome-wayland-nested-36.png" />|
GNOME 42, X11, Open |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-open-gnome-xsession-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-open-gnome-xsession-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-open-gnome-xsession-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-open-gnome-xsession-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-open-gnome-xsession-36.png" />|
GNOME 42, X11, Close |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-close-gnome-xsession-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-close-gnome-xsession-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-close-gnome-xsession-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-close-gnome-xsession-36.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-close-gnome-xsession-36.png" />|
GNOME 43, Wayland, Open |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-open-gnome-wayland-nested-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-open-gnome-wayland-nested-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-open-gnome-wayland-nested-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-open-gnome-wayland-nested-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-open-gnome-wayland-nested-37.png" />|
GNOME 43, Wayland, Close |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-close-gnome-wayland-nested-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-close-gnome-wayland-nested-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-close-gnome-wayland-nested-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-close-gnome-wayland-nested-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-close-gnome-wayland-nested-37.png" />|
GNOME 43, X11, Open |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-open-gnome-xsession-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-open-gnome-xsession-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-open-gnome-xsession-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-open-gnome-xsession-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-open-gnome-xsession-37.png" />|
GNOME 43, X11, Close |<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-a-close-gnome-xsession-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/energize-b-close-gnome-xsession-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/fire-close-gnome-xsession-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/portal-close-gnome-xsession-37.png" />|<img class="z-depth-2 rounded" width="70px" src="https://raw.githubusercontent.com/Schneegans/Burn-My-Windows/main/tests/references/hexagon-close-gnome-xsession-37.png" />|


## Running the Tests on GitHub

{% highlight yaml linenos %}
{% raw %}name: Tests

on:
  push:
    branches:
      - '**'
  pull_request:
    branches:
      - '**'

jobs:
  tests:
    name: Run Tests
    runs-on: ubuntu-latest
    if: >
      github.event_name == 'pull_request' ||
      ( contains(github.ref, 'main') && !contains(github.event.head_commit.message, '[no-ci]') ) ||
      contains(github.event.head_commit.message, '[run-ci]')
    strategy:
      fail-fast: false
      matrix:
        version:
          - '32'
          - '33'
          - '34'
          - '35'
          - '36'
          - '37'
        session:
          - 'gnome-xsession'
          - 'gnome-wayland-nested'
    steps:
    - uses: actions/checkout@v2
    - name: Download Dependencies
      run: |
        sudo apt update -qq
        sudo apt install gettext -qq
    - name: Build Extension
      run: make zip
    - name: Test Extension
      run: sudo $GITHUB_WORKSPACE/run-test.sh -v ${{ matrix.version }} -s ${{ matrix.session }}
    - uses: actions/upload-artifact@v2
      if: failure()
      with:
        name: log_${{ matrix.version }}_${{ matrix.session }}
        path: fail.log
    - uses: actions/upload-artifact@v2
      if: failure()
      with:
        name: screen_${{ matrix.version }}_${{ matrix.session }}
        path: fail.png{% endraw %}
{% endhighlight %}

As a final step, we need to run those test via GitHub Actions.
To do this, save the above YAML code as `.github/workflows/tests.yml` in your extension repository.
The workflow will be run on each push and each pull request.
However, I usually do not need to run all tests on all pushes to branches except for the `main` branch.
Therefore, I added the interesting `if` in line 15: This ensures that the tests are only executed in three cases:
* If the push happened to be part of a pull request.
* If something was pushed to `main` _and_ the commit message _did not_ contain `[no-ci]`.
* If something was pushed to any branch _and_ the commit message _did_ contain `[run-ci]`.

The `run-tests.sh` script will then be executed for each combination of the Fedora versions and Wayland / X11.
Whenever a test fails, the `fail.png` and `fail.log` will be uploaded (these are produced by the linked example test script if any of the tests fails).
As before, the "Download Dependencies" step may not be necessary for your extension.

## Wrapping Up

I hope that you learned something from these guides!
Maybe, one or the other aspect can be applied to your extension as well.
If you have any questions, suggestions, or alternative solutions, feel free to post a comment!

<div class="link-color-background well">
ℹ️ The post has been updated on March 04, 2022 to include the more advanced Burn-My-Windows example.
</div>

<div class="link-color-background well">
ℹ️ The post has been updated on January 18, 2023 to include the latest changes in the `gnome-shell-pod` container images.
</div>