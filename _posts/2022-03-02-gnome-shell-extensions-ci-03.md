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
* **[ghcr.io/schneegans/gnome-shell-pod-32](https://github.com/Schneegans/gnome-shell-pod/pkgs/container/gnome-shell-pod-32)**: GNOME Shell 3.36.9 (based on Fedora 32)
* **[ghcr.io/schneegans/gnome-shell-pod-33](https://github.com/Schneegans/gnome-shell-pod/pkgs/container/gnome-shell-pod-33)**: GNOME Shell 3.38.5 (based on Fedora 33)
* **[ghcr.io/schneegans/gnome-shell-pod-34](https://github.com/Schneegans/gnome-shell-pod/pkgs/container/gnome-shell-pod-34)**: GNOME Shell 40.4 (based on Fedora 34)
* **[ghcr.io/schneegans/gnome-shell-pod-35](https://github.com/Schneegans/gnome-shell-pod/pkgs/container/gnome-shell-pod-35)**: GNOME Shell 41.0 (based on Fedora 35)
* **[ghcr.io/schneegans/gnome-shell-pod-36](https://github.com/Schneegans/gnome-shell-pod/pkgs/container/gnome-shell-pod-36)**: GNOME Shell 42.beta (based on Fedora 36)

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
The following example script uses `podman cp` to copy the extension zip into the running container.
It then installs and enables the extension with `gnome-extensions install` and `gnome-extensions enable` respectively.
Thereafter, it launches GNOME Shell and closes the initial overview & welcome tour of GNOME 40+.
Finally, it opens the preferences window of the extension.

To test whether this worked, the virtual screen is searched for a sub-image of the preferences dialog.
For example, the Burn-My-Windows preferences dialog looks different on various GNOME versions.
So I made a screenshot of a small portion of the logo and saved it as [references/preferences.png](https://github.com/Schneegans/Burn-My-Windows/blob/main/tests/references/preferences.png) to the extension's repository.

<div class="row">
<div class="col s6">
{% assign picture = "burn-my-windows-40.jpg" %}
{% assign text = "Burn-My-Windows Preferences before GNOME 42." %}
{% include image.html %}
</div>
<div class="col s6">
{% assign picture = "burn-my-windows-42.jpg" %}
{% assign text = "Burn-My-Windows Preferences since GNOME 42." %}
{% include image.html %}
</div>
</div>

If the script fails at some point, a screenshot (`fail.png`) and log (`fail.log`) will be saved.
Later, these will be uploaded as assets by GitHub Actions so that we can learn why a pipeline failed.

Just save the following code as `run-tests.sh` in the root directory of your extension repository.
I use a bash script here, however you could also use any other scripting language.
Please study the code carefully; I tried to explain everything with inline comments.

{% highlight bash linenos %}
#!/bin/bash

# The script supports two arguments:
#
# -v fedora_version: This determines the version of GNOME Shell to test against.
#                    -v 32: GNOME Shell 3.36
#                    -v 33: GNOME Shell 3.38
#                    -v 34: GNOME Shell 40
#                    -v 35: GNOME Shell 41
#                    -v 36: GNOME Shell 42
# -s session:        This can either be "gnome-xsession" or "gnome-wayland-nested".

# Exit on error.
set -e

usage() {
  echo "Usage: $0 -v fedora_version -s session" >&2
}

FEDORA_VERSION=33
SESSION="gnome-xsession"

while getopts "v:s:h" opt; do
  case $opt in
    v) FEDORA_VERSION="${OPTARG}";;
    s) SESSION="${OPTARG}";;
    h) usage; exit 0;;
    *) usage; exit 1;;
  esac
done

# Go to the repo root.
cd "$( cd "$( dirname "$0" )" && pwd )" || \
  { echo "ERROR: Could not find the repo root."; exit 1; }

IMAGE="ghcr.io/schneegans/gnome-shell-pod-${FEDORA_VERSION}"
EXTENSION="my-cool-extension@my.cool.domain.com"

# Run the container. For more info, visit https://github.com/Schneegans/gnome-shell-pod.
POD=$(podman run --rm --cap-add=SYS_NICE --cap-add=IPC_LOCK -td "${IMAGE}")

# Properly shutdown podman when this script is exited.
quit() {
  podman kill "${POD}"
  wait
}

trap quit INT TERM EXIT

# -------------------------------------------------------------------------------- methods

# This function is used below to execute any shell command inside the running container.
do_in_pod() {
  podman exec --user gnomeshell --workdir /home/gnomeshell "${POD}" set-env.sh "$@"
}

# This is called whenever a test fails. It prints an error message (given as first
# parameter), captures a screenshot to "fail.png" and stores a log in "fail.log".
fail() {
  echo "${1}"
  podman cp "${POD}:/opt/Xvfb_screen0" - | tar xf - --to-command 'convert xwd:- fail.png'
  LOG=$(do_in_pod sudo journalctl | grep -C 5 "error\|gjs")
  echo "${LOG}" > fail.log
  exit 1
}

# This searches the virtual screen of the container for a given target image (first
# parameter). If it is not found, an error message (second parameter) is printed and the
# script exits via the fail() method above.
find_target() {
  echo "Looking for ${1} on the screen."
  POS=$(do_in_pod find-target.sh "${1}") || true
  if [[ -z "${POS}" ]]; then
    fail "${2}"
  fi
}

# This simulates the given keystroke in the container. Simply calling "xdotool key $1"
# sometimes fails to be recognized. Maybe the default 12ms between key-down and key-up
# are too short for xvfb...
send_keystroke() {
  do_in_pod xdotool keydown "${1}"
  sleep 0.5
  do_in_pod xdotool keyup "${1}"
}


# ----------------------------------------------------- wait for the container to start up

echo "Waiting for D-Bus."
do_in_pod wait-user-bus.sh > /dev/null 2>&1


# ----------------------------------------------------- install the to-be-tested extension

echo "Installing extension."

# This directory contains the reference images of the
# settings dialog we will be searching for later.
podman cp "references" "${POD}:/home/gnomeshell/references"

# Copy the extension bundle.
podman cp "${EXTENSION}.zip" "${POD}:/home/gnomeshell"

# Enable the extension.
do_in_pod gnome-extensions install "${EXTENSION}.zip"
do_in_pod gnome-extensions enable "${EXTENSION}"


# ---------------------------------------------------------------------- start GNOME Shell

# Starting with GNOME 40, there is a "Welcome Tour" dialog popping up at first launch.
# We disable this beforehand.
if [[ "${FEDORA_VERSION}" -gt 33 ]]; then
  echo "Disabling welcome tour."
  do_in_pod gsettings set org.gnome.shell welcome-dialog-last-shown-version "999" || true
fi

echo "Starting $(do_in_pod gnome-shell --version)."
do_in_pod systemctl --user start "${SESSION}@:99"
sleep 10

# Starting with GNOME 40, the overview is the default mode. We close this here by hitting
# the super key.
if [[ "${FEDORA_VERSION}" -gt 33 ]]; then
  echo "Closing Overview."
  send_keystroke "super"
  sleep 3
fi


# ---------------------------------------------------------------------- perform the tests

# Finally, we open the preferences and check whether the window is shown on screen by
# searching for a small snippet of the preferences dialog.
echo "Opening Preferences."
do_in_pod gnome-extensions prefs "${EXTENSION}"
sleep 3
find_target "references/preferences.png" "Failed to open preferences!"

echo "All tests executed successfully."
{% endhighlight %}

The script can be run like this:

```bash
make zip                                       # From Part I of the series
./run-tests.sh -v 33 -s gnome-xsession         # Test on Fedora 33 / X11
./run-tests.sh -v 36 -s gnome-wayland-nested   # Test on Fedora 36 / Wayland
```

This is just a minimal example for how such a testing script could look like.
Of course, you can do this completely differently!
You could also add a test API to your extension which you call from the script.
There are many other things which could be done and with a bit of creativity, this can be easily expanded to cover many use-cases!
For example, the [test script of Fly-Pie](https://github.com/Schneegans/Fly-Pie/blob/main/tests/run-test.sh) uses `xdotool` to move the mouse pointer and to click on menu items.

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
Whenever a test fails, the `fail.png` and `fail.log` will be uploaded.
As before, the "Download Dependencies" step may not be necessary for your extension.

## Wrapping Up

I hope that you learned something from these guides!
Maybe, one or the other aspect can be applied to your extension as well.
If you have any questions, suggestions, or alternative solutions, feel free to post a comment!