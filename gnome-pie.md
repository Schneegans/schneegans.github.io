---
layout: nav-page
title : Gnome-Pie
header : Gnome-Pie
group: featured-projects
---

Gnome-Pie is a circular application launcher for Linux. It is made of several pies, each consisting of multiple slices. The user presses a key stroke which opens the desired pie. By activating one of its slices, applications may be launched, key presses may be simulated or files can be opened.

<div class="responsive-video-169">
<iframe src="http://player.vimeo.com/video/30618179?title=0&amp;byline=0&amp;portrait=0&amp;color={% include link_color %}" width="1600" height="900" frameborder="0" webkitAllowFullScreen allowFullScreen></iframe>
</div>
<br>

## The concept of Gnome-Pie

Gnome-Pie is designed to be fun, fast and visually appealing. It implements Fitts' law, which...

<div class="well"> [...] is a model of human movement primarily used in human–computer interaction and ergonomics that predicts that the time required to rapidly move to a target area is a function of the distance to the target and the size of the target.<a href="http://en.wikipedia.org/wiki/Fitts's_law"> - Wikipedia</a></div>

Many application launchers of today's Linux desktops are made for people using their keyboard mainly. Launchers like <a href="http://do.davebsd.com/">Gnome-Do</a>, <a href="https://launchpad.net/synapse-project">Synapse</a>, <a href="http://kaizer.se/wiki/kupfer/">Kupfer</a>, Unity's Dash or Gnome-Shell's Activities are designed for keyboard users. It's necessary to type the first letters of the desired action in order to launch it.

Gnome-Pie uses a different approach: The user does not need to remember the name of an application - just the <em>direction</em> has to be remembered. Combined with the implementations of Fitts' law - users don't have to click directly on the icon of an action, but somewhere on the screen in its direction - Gnome-Pie is an alternative to text-based launchers.

## Gnome-Pie in action

Here's another showcase of Gnome-Pie. It features the new settings menu of Gnome-Pie.

<div class="responsive-video-169">
<iframe src="http://player.vimeo.com/video/35385121?title=0&amp;byline=0&amp;portrait=0&amp;color={% include link_color %}" width="1600" height="900" frameborder="0" webkitAllowFullScreen allowFullScreen></iframe>
</div>
<br>

<br/>
<br/>

# Installation of Gnome-Pie
<hr>

{% assign picture = "install.jpg" %}
{% assign size = "large" %}
{% assign text = "How to install Gnome-Pie!" %}
{% include image %}

Besides from installing from source there are other ways to install Gnome-Pie. I maintain a PPA for easy installation on ubuntu-ish distributions and there are several repositories for other distributions, like <a href="https://aur.archlinux.org/packages.php?ID=52732&detail=0">Arch Linux</a>.

## Installation from my PPA

This works for Ubuntu and similar distributions. Simply enter the following commands in a terminal.

{% highlight bash %}
sudo add-apt-repository ppa:simonschneegans/testing
sudo apt-get update
sudo apt-get install gnome-pie
{% endhighlight %}

When this is done, you can launch the application via your main menu. It will start silently, only an indicator in your panel will be visible. Press Ctrl-Alt-A to open an example pie.

## Installation from source

This is not more difficult at all. First of all, install all dependancies - this command again is for Debian-flavored distributions; if you've got another package manager you'll have to change this command accordingly. The dependancy libappindicator-dev is optional, if your distribution does not support this system, simply ignore it. Install the following dependencies:

{% highlight bash %}
sudo apt-get install git build-essential libgtk-3-dev libcairo2-dev libappindicator3-dev libgee-0.8-dev libxml2-dev libxtst-dev libgnome-menu-3-dev valac cmake libbamf3-dev libwnck-3-dev bamfdaemon
{% endhighlight %}

Then download Gnome-Pie from GIT, compile and install it:

{% highlight bash %}
git clone git://github.com/Simmesimme/Gnome-Pie.git
cd Gnome-Pie && ./make.sh
cd build && sudo make install
{% endhighlight %}

Then you can launch the application via your main menu. It will start silently, only an indicator in your panel will be visible. Press Ctrl-Alt-A to open an example pie.

<br/>
<br/>

# Using Gnome-Pie
<hr>

{% assign picture = "use.jpg" %}
{% assign size = "large" %}
{% assign text = "How to use Gnome-Pie!" %}
{% include image %}

## Tweaking the behavior of Gnome-Pie

{% assign picture = "gnome-pie_06.jpg" %}
{% assign size = "large" %}
{% assign text = "The settings menu of Gnome-Pie" %}
{% include image_right %}
By clicking on the panel-indicator of Gnome-Pie or by launching the application a second time, you can open its settings menu.

Here you can set up your Pies. All your Pies are listed on the left --- you can add new or delete existing pies with the little plus and minus sign in the lower left-hand corner. On the right is a preview of each Pie. Simply drag and drop the Slice to reorder them. You can drag stuff from your computer to this preview in order to add it to the Pie.

By clicking on the "General Settings"-button in the toolbar, you can specify some behavior options (such as <em>Startup on Login</em> or a <em>Global Scale</em> factor). Furthermore you can select a theme which skins all of your pies to match your taste.

## Advanced Usage

It's not comfortable to press a complicated key stroke in order to open a pie. Here I present several ways which make the usage of Gnome-Pie much more fluent. All of these are based on one feature of Gnome-Pie: You can open any pie with a terminal command:

{% highlight bash %}
gnome-pie -o 123
{% endhighlight %}

Where _123_ is the ID of the desired pie. The ID of each pie is displayed in the options menu. These ID's are chosen randomly, so your ID's may be different to mine.

### Opening pies with gestures

{% assign picture = "gnome-pie_04.jpg" %}
{% assign size = "large" %}
{% assign text = "Assigning gestures with easystroke" %}
{% include image_right %}
With the open source application _Easystroke_ you can easily execute any command when performing a user defined action. You can install this tool and bind each pie you want to a gesture. For example you may draw a big B on your screen to open the bookmarks-pie. It's easy to set up and really cool!

Easystroke has an interface which is quite to understand. If you want some additional information you can have a look at the <a href="http://sourceforge.net/apps/trac/easystroke/wiki/Documentation">official documentation</a>.

### Opening pies with a Launcher

{% assign picture = "gnome-pie_03.jpg" %}
{% assign size = "large" %}
{% assign text = "Creating a launcher for opening pies" %}
{% include image_right %}
You can also create a launcher on your desktop which opens pies. Simply drag'n'drop a pie from the configuration menu to your desktop. Where you dropped the pie, a launcher will appear. Clicking on this launcher will then open your pie. Maybe you can drag'n'drop this launcher to your panel/dock/whats-o-ever to suit your needs!

<div class="clearfix"></div>

### Opening pies with Compiz edges

{% assign picture = "gnome-pie_07.jpg" %}
{% assign size = "large" %}
{% assign text = "Using the Advanced Compiz-Config-Settings-Manager to open pies" %}
{% include image_right %}
If you're using Compiz as your composition manager you can assign commands to the edges and corners of your screen. Consequently you can open pies simply by touching the edge of your screen with your pointer.

All you need is the _compizconfig-settings-manager_. You may install it from your package manager.

<div class="clearfix"></div>

{% assign picture = "gnome-pie_08.jpg" %}
{% assign size = "large" %}
{% assign text = "Selecting an edge to open a pie" %}
{% include image_right %}
Open the compizconfig-settings-manager: In the configuration of the plugin <em>Commands</em> enter <code>gnome-pie -o 123</code> (with 123 being the ID of your desired pie). Then select an edge in the <em>Edge Bindings</em> tab.

When you now move your mouse towards the selected edge, the pie with the specified ID will pop up.

<div class="clearfix"></div>


<br/>
<br/>

# Getting involved
<hr>

{% assign picture = "contribute.jpg" %}
{% assign size = "large" %}
{% assign text = "Contribute to Gnome-Pie!" %}
{% include image %}


## I need your help!

I really like working on Gnome-Pie --- and you can help improving it! There are many people sending mails to me, praising the possibilities Gnome-Pie offers to them. But I think it can be even better! Let's try to improve this piece of software together! There are multiple things you can do in order to become a part of Gnome-Pie's history:

### Report bugs!

For me it's the first project involving Vala, Gtk and Cairo. I never used these tools before, so I assume there is much to be improved. The easiest way to get involved is to fork the <a href="https://github.com/Simmesimme/Gnome-Pie">project on Github</a>. Or send an e-mail to code(at)simonschneegans.de. If you want to report a bug, please open an issue at the <a href="https://github.com/Simmesimme/Gnome-Pie">project page at github.com</a>.

### Translate Gnome-Pie!

This is really easy: There is an [easy-to-follow step-by-step-guide available]({% post_url 2011-11-09-translate-gnome-pie %})!

### Code for Gnome-Pie!

If you know Vala or are willing to learn (it's incredibly easy, like C# --- you'll love this language if you happen to know C++ or Java), you may check the <a href="https://github.com/Simmesimme/Gnome-Pie/issues">issues at Github.com</a>. Or you may introduce a total new feature you always wanted in Gnome-Pie!

### Donate!

If you can't afford the time to do the stuff mentioned above, but still want to help --- you can help improving this software by buying some drinks for a poor student! You can do this with <a href="http://flattr.com/thing/468485/Gnome-Pie">Flattr</a> or by <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=X65SUVC4ZTQSC">donating via PayPal</a>. If you happen to dislike PayPal, send a mail to code@simonschneegans.de and we can chat about this!

## The code of Gnome-Pie

If you want to write code for Gnome-Pie, please have a look at the existing files concerning style. I tried to adopt some common Vala guidelines while defining my own style. It's not always consistent but I try to follow at least most of the time some simple rules:
<ul>
    <li>Tab-width: Four spaces. Please insert spaces instead of tabs.</li>
    <li>No line should be longer than 100 characters.</li>
    <li>The code should be formatted in Java-style (see example below).</li>
    <li>Member variables should be declared before methods.</li>
    <li>Public before private.</li>
    <li>CamelCase for class names, underscore_separated for all other identifiers.</li>
    <li>Comments describing entire classes/methods/members should be in doxygen-style (see example below).</li>
</ul>

An example of well-formatted code:

{% highlight c++ %}
/////////////////////////////////////////////////////////////////////
/// Some cool method.
/////////////////////////////////////////////////////////////////////

public string does_cool_stuff(int input) {
    string local_variable = "";

    // this is the mighty part!
    if (input < 0) {
        local_variable = "%u".printf(-input);
    } else {
        local_variable = "%u".printf(input);
    }

    return local_variable;
}
{% endhighlight %}
