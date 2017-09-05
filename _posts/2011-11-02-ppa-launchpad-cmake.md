---
layout: post
title: "PPA with CMake!"
tagline: "learn it with a detailed step-by-step guide."
category: lessons
teaser: "launchpad.jpg"
colors: "color-launchpad"
tags: ["tutorial", "featured", "c++", "cmake", "code"]
---

When I first wanted to create a PPA for Ubuntu, it was a pain. It was barely documented, unnecessarily complex and --- the worst thing of all --- if there was a tutorial, it employed rather old build tools and no guide covered code generated with CMake.

<!--more-->

## Motivation

The goal was to upload <a href="http://mars-game.sourceforge.net/">M.A.R.S.</a> to a PPA: M.A.R.S. uses CMake and I did not find any resource how to create a source package which launchpad would compile. With this tutorial I want to help those being in a similar situation I was some months ago. Please remark that I don't have inside knowledge on what is going on here --- it is the result of trial and error, but it works as supposed! So let's get started...


## 1. A short inroduction

So first of all --- for those not knowing it --- what is a PPA?

A PPA is a Personal Package Archive hosted on <a href="https://launchpad.net/">launchpad</a>. Developers can upload source code to this archive which then will be build automatically for various releases of Ubuntu in a 32 bit and a 64 bit version. These archives can easily be added to the software sources of any Ubuntu-based Linux distribution, making it very easy to install the software on end-user systems.

This tutorial will show you how to create and upload a source package to launchpad. This source package will contain a minimal application written in C++ which gets configured with CMake.

<div class="alert well">The tutorial assumes you have knowledge in a programming language supported by CMake and in CMake itself. Even if I will provide copy&paste code snippets, I won't explain how CMake works on a general basis.</div>

The software requirements are CMake, the GCC and some packaging scripts. You can install them with the following command:

{% highlight bash %}
sudo apt-get install build-essential cmake devscripts
{% endhighlight %}


## 2. A minimal application with CMake

First create an empty directory called "greet-the-world". Open a text editor of your choice and paste the following code into it.

{% highlight c++ %}
## include <iostream>

int main() {
    std::cout << "Hello World!" << std::endl;
    return 0;
}
{% endhighlight %}

Save the file as main.cpp in the newly created directory. This is the program which will serve as a basic example for this tutorial. Now it's time to create a CMake-script which will generate a makefile for automatic compilation. Save the following file as CMakeLists.txt in the same directory as your main.cpp.

{% highlight cmake %}
project(greet-the-world)

cmake_minimum_required(VERSION 2.6)

set(EXECUTABLE_OUTPUT_PATH ${greet-the-world_SOURCE_DIR})

add_executable(greet-the-world main.cpp)

install(
    TARGETS
        greet-the-world
    RUNTIME DESTINATION
        ${CMAKE_INSTALL_PREFIX}/bin
)
{% endhighlight %}

If you execute the following commands, your program should be build. They create a new directory called "build" inside your source directory. From there CMake is executed, creating a makefile which then is used to compile the source code. When all works according to plan, the last command should print "Hello World!" to your console.

{% highlight bash %}
cd greet-the-world
mkdir build && cd build
cmake ..
make
cd .. && ./greet-the-world
{% endhighlight %}

If everything works as supposed, clean up again:

{% highlight bash %}
rm -rf build
rm greet-the-world
{% endhighlight %}


## 3. Creating a source package

This step involves creation of four files which are needed by launchpad. They describe how the debian package should be build, what are the dependencies of the package and so on. They are all placed in a folder called "debian" in the source directory.

{% highlight bash %}
cd greet-the-world
mkdir debian && cd debian
{% endhighlight %}


### 3.1 The control file

Now we will go through each individual file and check what it is for. You can download the file of each section with the given command. Just execute it inside the "debian"-directory and open the downloaded file in an editor of your choice. Or copy & paste the contents from below.

{% highlight bash %}
wget http://www.simonschneegans.de/assets/files/ppa-howto/control
{% endhighlight %}

{% highlight bash %}
Source: greet-the-world
Section: devel
Priority: optional
Maintainer: Your Name <your.email@some.where>
Build-Depends: cmake, build-essential
Homepage: http://www.yourhomepage.org

Package: greet-the-world
Architecture: any
Depends:
Description: First test-package
 Long description of greet-the-world.
 It can span multiple lines!
{% endhighlight %}


This first file is "control". It specifies which packages are needed for building your package, what it is called and some information on you. The first section of the file describes the source package. The second part is the configuration for the resulting binary package.

You'll have to write your name and e-mail address to the appropriate fields.


### 3.2 The rules file

The second file, "rules", is very important, too. It tells launchpad how to exactly compile your application. It is basically a normal makefile with some special targets, which are invoked by launchpad.

{% highlight bash %}
wget http://www.simonschneegans.de/assets/files/ppa-howto/rules
{% endhighlight %}

{% highlight bash %}
#!/usr/bin/make -f

BUILDDIR = build_dir

# secondly called by launchpad
build:
    mkdir $(BUILDDIR);
    cd $(BUILDDIR); cmake -DCMAKE_INSTALL_PREFIX=../debian/tmp/usr ..
    make -C $(BUILDDIR)

# thirdly called by launchpad
binary: binary-indep binary-arch

binary-indep:
    # nothing to be done

binary-arch:
    cd $(BUILDDIR); cmake -P cmake_install.cmake
    mkdir debian/tmp/DEBIAN
    dpkg-gencontrol -pgreet-the-world
    dpkg --build debian/tmp ..

# firstly called by launchpad
clean:
    rm -f build
    rm -rf $(BUILDDIR)

.PHONY: binary binary-arch binary-indep clean
{% endhighlight %}

The target "clean" is called firstly. Then launchpad will execute "build", which does the same thing as we tested above. It will create a build directory, change to it, execute CMake (with the install prefix set to a directory inside the debian directory) and compile the application.
When this succeeds, the package will be build with the target "binary-arch".

You don't need to alter the content of this file.

### 3.3 The changelog file

The third file is "changelog". It contains some information on what you have done since the last release.

{% highlight bash %}
wget http://www.simonschneegans.de/assets/files/ppa-howto/changelog
{% endhighlight %}

{% highlight bash %}
greet-the-world (0.1-0ppa0) oneiric; urgency=low

  * Initial upload!

 -- Your Name <your.email@some.where>  Tue, 01 Nov 2011 20:32:17 +0100
{% endhighlight %}

The first line specifies for what distribution your package is made and its version. Then there can be multiple lines containing the change log information. The last line has to be _exactly_ like it is shown there. Mind the **two spaces** after your e-mail address! Without them, your package will be rejected!

Please change the date and the e-mail address accordingly. The date string can be obtained by the terminal command `date -R`.

### 3.4 The copyright file

The last file contains your copyright information. It does not follow any structure and can contain everything you want. Here is a GPL-3 example. Just insert your name.

{% highlight bash %}
wget http://www.simonschneegans.de/assets/files/ppa-howto/copyright
{% endhighlight %}

{% highlight bash %}
####################################################################
#                    greet-the-world                               #
####################################################################

Copyright (C) 2011 Your Name

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
{% endhighlight %}



## 4. Uploading to launchpad

Now, all necessary files have been created. The project is ready to be uploaded to launchpad! Therefore you will have to have a launchpad account. If you don't already have one, please create one now. You will have to do some nasty stuff then --- like uploading RSA-keys, signing the Ubuntu Code of Conduct and sharing OpenPGP-keys --- but this is well documented at the launchpad help pages. Here are some links which may be useful:

* [Create and personalise your launchpad account](https://help.launchpad.net/YourAccount/NewAccount)
* [Import an OpenPGP key to launchpad](https://help.launchpad.net/YourAccount/ImportingYourPGPKey)
* [Import your SSH keys](https://help.launchpad.net/YourAccount/CreatingAnSSHKeyPair)
* [Activating your PPA](https://help.launchpad.net/Packaging/PPA)


### 4.1 The initial upload

Now you're ready to upload your first package to launchpad! Just a few steps are needed to do so. First of all, you need to create a .tar.gz of your original source code and name it greet-the-world_0.1.orig.tar.gz. Then the package is created from within the folder "greet-the-world". Finally you upload the package with dput to launchpad. Be sure to replace ppa:yourppa/name with your PPA.

{% highlight bash %}
tar -acf greet-the-world_0.1.orig.tar.gz greet-the-world
cd greet-the-world
debuild -S -sa
cd ..
dput ppa:yourppa/name greet-the-world_0.1-0ppa0_source.changes
{% endhighlight %}

That's all! You've done it!

Check your PPA's website, there you can monitor the build status of your package. When it fails for some reason, launchpad will send you an e-mail containing information on the reason. If all works, you can now add the PPA to your system and install greet-the-world with synaptic!


### 4.2 Further uploads

If you want to upload a new version of your software, use the following commands. Before you have to create a new changelog file: remember to insert the new version number and the current date! In the terminal command below, you'll have to change the file name accordingly.

{% highlight bash %}
cd greet-the-world
debuild -S -sd
cd ..
dput ppa:yourppa/name greet-the-world_0.1-0ppa0_source.changes
{% endhighlight %}


## 5. Conclusions

This is how I managed to upload code to launchpad. Once you understand the procedure, it's quite easy --- but I remember many difficulties at the beginning! Maybe a lot can be done more efficiently, maybe some steps are not done as supposed... but it works!

If you got some questions or remarks... use the comment form below!
