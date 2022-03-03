---
layout: post
title: "GNOME Shell Extensions & CI: Part I"
category: tutorials
teaser: "ci1.jpg"
colors: "color-ci1"
license: "public domain"
tagline: "Testing your code is important."
tags: ["tutorial"]
---

In this guide, I will show how I run automated tests for each commit to the repositories of my GNOME Shell extensions.

<!--more-->

I am currently maintaining three popular GNOME Shell extensions: [Fly-Pie](https://github.com/Schneegans/Fly-Pie), [The Desktop-Cube](https://github.com/Schneegans/Desktop-Cube), and [Burn-My-Windows](https://github.com/Schneegans/Burn-My-Windows).
Each of those support several versions of GNOME Shell.
Testing each and every new feature on all supported versions would be a very time-consuming process.
Therefore, I set up a continuous integration (CI) process using [GitHub Actions](https://github.com/features/actions).

<div class="link-color-background well">
ℹ️ With this guide, I want to share what I have learned. I hope that you can learn something as well!
</div>

## The Idea

For each pull request and each commit to the `main` branch, a series of jobs is executed on the runners of GitHub.
For this, I am using [podman](https://podman.io/) containers with fully working versions of GNOME Shell running on [xvfb](https://en.wikipedia.org/wiki/Xvfb).
Of course, only the features which are actually tested are guaranteed to work, but most compatibility issues will cause the extension either to not load at all or the preferences dialog to crash.
And both of these errors are easy to catch.

Furthermore, I use GitHub Actions to automatically create a bundled extension whenever a tag is pushed to the repository, which I can then directly upload to extensions.gnome.org.
This ensures that I publish consistent release packages with no spurious files which I forgot to delete.

## Getting Started

This post is the first of a three-part series.
Here are links to the other parts:

1. Bundling the Extension (this post)
2. [Automated Release Publishing]({% post_url 2022-03-01-gnome-shell-extensions-ci-02 %})
3. [Automated Tests with GitHub Actions]({% post_url 2022-03-02-gnome-shell-extensions-ci-03 %})

This guide assumes that you have solid background knowledge regarding the development of GNOME Shell extensions.
Basically, you should have a GNOME Shell extension at hand to which you want to apply this guide.
Also, this guide only shows how I implemented the CI jobs.
Most things can be done in various ways: You do not have to use a `makefile`, you do not have to use shell scripts (any other scripting language will work as well), and you even do not have to use GitHub Actions (this can also be translated to GitLab CI, for example).

## Bundling the Extension

In this first part of the series, I will show you the `makefile` which I use to bundling, installing, and uninstalling my extensions.

<div class="link-color-background well">
ℹ️ If your extension already contains a `makefile` or something similar which can be used to bundle the extension, you can directly skip to the second part. Or you can continue reading, maybe you find something useful 😉
</div>

The `makefile` below assumes that it is placed in the source tree next to the `metadata.json`, `extension.js`, and `prefs.js`.
It will bundle these as well as any other JavaScript files, and the top-level `LICENSE` file into the extension zip file.
It will also compile the schema xml in the `schemas` directory and include the resulting `gschemas.compiled` file.
Here's a schematic overview how the source directory could look like:

{% highlight linenos %}
my-cool-extension@my.cool.domain.com
 |
 |- schemas/
 |   '- org.gnome.shell.extensions.my-cool-extension.gschema.xml
 |
 |- resources/
 |   |- any-data-directory/
 |   |- another-data-directory/
 |   '- my-cool-extension.gresource.xml
 |
 |- arbitrary-src-directory-name/
 |   |- *.js
 |   '-  ...
 |
 |- extension.js
 |- metadata.json
 |- prefs.js
 |- LICENSE
 '- makefile

{% endhighlight %}

You can simply copy the code below to a new file called `makefile`.
Read the code carefully, there are a few things which will need to be adapted to your extension.
Once the file is created and adapted, you can run these four targets:

* `make zip` will create the extension bundle.
* `make install` will create the bundle and install it for the current user.
* `make uninstall` will uninstall the previously installed extension.
* `make clean` will remove all temporary files, including the zip file.

{% highlight make linenos %}
SHELL := /bin/bash

# Replace these with the name and domain of your extension!
NAME     := my-cool-extension
DOMAIN   := my.cool.domain.com
ZIP_NAME := $(NAME)@$(DOMAIN).zip

# These files will be included in the extension zip. If you have additional files in your
# extension, these should be added here.
JS_FILES    = $(shell find -type f -and \( -name "*.js" \))
ZIP_CONTENT = $(JS_FILES) schemas/gschemas.compiled metadata.json LICENSE

# These four recipes can be invoked by the user.
.PHONY: zip install uninstall clean

# The zip recipes only bundles the extension without installing it.
zip: $(ZIP_NAME)

# The install recipes creates the extension zip and installs it.
install: $(ZIP_NAME)
	gnome-extensions install "$(ZIP_NAME)" --force
	@echo "Extension installed successfully! Now restart the Shell ('Alt'+'F2', then 'r')."

# This uninstalls the previously installed extension.
uninstall:
	gnome-extensions uninstall "$(NAME)@$(DOMAIN)"

# This removes all temporary files created with the other recipes.
clean:
	rm -f $(ZIP_NAME) \
	      schemas/gschemas.compiled

# This bundles the extension and checks whether it is small enough to be uploaded to
# extensions.gnome.org. We do not use "gnome-extensions pack" for this, as this is not
# readily available on the GitHub runners.
$(ZIP_NAME): $(ZIP_CONTENT)
	@echo "Packing zip file..."
	@rm --force $(ZIP_NAME)
	@zip $(ZIP_NAME) -- $(ZIP_CONTENT)

	@#Check if the zip size is too big to be uploaded
	@SIZE=$$(unzip -Zt $(ZIP_NAME) | awk '{print $$3}') ; \
	 if [[ $$SIZE -gt 5242880 ]]; then \
	    echo "ERROR! The extension is too big to be uploaded to" \
	         "the extensions website, keep it smaller than 5 MB!"; \
	    exit 1; \
	 fi

# Compiles the gschemas.compiled file from the gschema.xml file.
schemas/gschemas.compiled: schemas/org.gnome.shell.extensions.$(NAME).gschema.xml
	@echo "Compiling schemas..."
	@glib-compile-schemas schemas
{% endhighlight %}

<div class="link-color-background well">
💞 Btw, I want to send a big THANKS to GitHub user <a href="https://github.com/daPhipz">@daPhipz</a> who helped me a lot in setting up these makefiles!
</div>

### Adding Resources

While the above makefile may be sufficient for most simple extensions, it will need to be expanded for more complex use cases.
One of these is the inclusion of a `*.gresource` file.
The version below will automatically create a temporary `resources/NAME.gresource.xml` file containing entries for all files in the `resources/` directory.
Once this intermediate file is created, it is compiled to `resources/NAME.gresource` which will be included in the zip file.

Compared to the version above, only a few lines have been changed.
The `.gresource` file has been added to the `ZIP_CONTENT` in line 11.
All resource files which shall be included are globbed in line 16.
Then, the `clean` recipe has been expanded to remove the new temporary files again.
Last but not least, two private recipes have been added to the end of the file (lines 61-71) for creating the compiled resource files.

{% highlight make linenos %}
SHELL := /bin/bash

# Replace these with the name and domain of your extension!
NAME     := my-cool-extension
DOMAIN   := my.cool.domain.com
ZIP_NAME := $(NAME)@$(DOMAIN).zip

# These files will be included in the extension zip. If you have additional files in your
# extension, these should be added here.
JS_FILES    = $(shell find -type f -and \( -name "*.js" \))
ZIP_CONTENT = $(JS_FILES) resources/$(NAME).gresource \
              schemas/gschemas.compiled metadata.json LICENSE

# All non-toplevel files in the 'resource' directory will be compiled to
# a gresource file.
RESOURCE_FILES = $(shell find resources -mindepth 2 -type f)

# These four recipes can be invoked by the user.
.PHONY: zip install uninstall clean

# The zip target only bundles the extension without installing it.
zip: $(ZIP_NAME)

# The install target creates the extension zip and installs it.
install: $(ZIP_NAME)
	gnome-extensions install "$(ZIP_NAME)" --force
	@echo "Extension installed successfully! Now restart the Shell ('Alt'+'F2', then 'r')."

# This uninstalls the previously installed extension.
uninstall:
	gnome-extensions uninstall "$(NAME)@$(DOMAIN)"

# This removes all temporary files created with the other recipes.
clean:
	rm -f $(ZIP_NAME) \
	      resources/$(NAME).gresource \
	      resources/$(NAME).gresource.xml \
	      schemas/gschemas.compiled

# This bundles the extension and checks whether it is small enough to be uploaded to
# extensions.gnome.org. We do not use "gnome-extensions pack" for this, as this is not
# readily available on the GitHub runners.
$(ZIP_NAME): $(ZIP_CONTENT)
	@echo "Packing zip file..."
	@rm --force $(ZIP_NAME)
	@zip $(ZIP_NAME) -- $(ZIP_CONTENT)

	@#Check if the zip size is too big to be uploaded
	@SIZE=$$(unzip -Zt $(ZIP_NAME) | awk '{print $$3}') ; \
	 if [[ $$SIZE -gt 5242880 ]]; then \
	    echo "ERROR! The extension is too big to be uploaded to" \
	         "the extensions website, keep it smaller than 5 MB!"; \
	    exit 1; \
	 fi

# Compiles the gschemas.compiled file from the gschema.xml file.
schemas/gschemas.compiled: schemas/org.gnome.shell.extensions.$(NAME).gschema.xml
	@echo "Compiling schemas..."
	@glib-compile-schemas schemas

# Compiles the gresource file from the gresources.xml.
resources/$(NAME).gresource: resources/$(NAME).gresource.xml
	@echo "Compiling resources..."
	@glib-compile-resources --sourcedir="resources" --generate resources/$(NAME).gresource.xml

# Generates the gresources.xml based on all files in the resources subdirectory.
resources/$(NAME).gresource.xml: $(RESOURCE_FILES)
	@echo "Creating resources xml..."
	@FILES=$$(find "resources" -mindepth 2 -type f -printf "%P\n" | xargs -i echo "<file>{}</file>") ; \
	 echo "<?xml version='1.0' encoding='UTF-8'?><gresources><gresource> $$FILES </gresource></gresources>" \
	     > resources/$(NAME).gresource.xml
{% endhighlight %}

With this `makefile`, whenever `make zip` or `make install` is executed, all files which are in subdirectories of the `resources/` directory will be compiled into a `*.gresource` file and included in your extension zip.

### Adding Translation Support

It is also quite straight-forward to make the `makefile` compile all `*.po` files and include the resulting `*.mo` files in the zip.
For an example of this, you can have a look at the [makefile of the Desktop-Cube extension](https://github.com/Schneegans/Desktop-Cube/blob/main/Makefile).

## Up Next: Automated Release Publishing

That's it for now!
I hope that you learned something useful for the development of your GNOME Shell extension.
In the [next part of this series]({% post_url 2022-03-01-gnome-shell-extensions-ci-02 %}), we will see how we can use GitHub Actions to automatically publish the bundled extension whenever a new tag is pushed.