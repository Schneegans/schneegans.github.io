---
layout: post
title: "Create a theme for Gnome-Pie!"
tagline: "it will look awesome."
category: lessons
teaser: "themes_for_gnome-pie.jpg"
colors: "color-themes_for_gnome-pie"
description: "Designing themes is fun!"
tags: ["tutorial", "gnome-pie"]
---

It is quite easy to create custom themes for Gnome-Pie. All you need to do is creating some images and editing an XML-file to make the theme behave as you want. With this little tutorial I'll give an overview of the steps needed to create a theme.

<!--more-->

The themes of Gnome-Pie are either installed to `/usr/share/gnome-pie/themes` or `/usr/local/share/gnome-pie/themes` - you can have a look at these to get an impression.

When you create a new theme you should put it in your home directory in `~/.config/gnome-pie/themes`, there they'll discovered as well.

##1. Decide what you want

This step might be difficult if it's your very first theme due to your limited knowledge on what is possible with the themes of Gnome-Pie. Therefore I list some possibilities and restrictions here:

* Each theme consists of an arbitrary amount of image layers for the center and the slices of a pie.
* An image can be in various formats (svg, png, jpg, ...) and sizes. But it is best if all images are svg's. These are very small in size and can be scaled without any artifacts.
* Slice layers have two states: when the mouse hovers over a slice, this slice is <em>active</em> else it is <em>inactive</em>.
* The same applies to center layers: when any slice of the pie is hovered, the center is <em>active</em>. If no slice is hovered (e.g. the mouse is on the center of the pie), the center is called <em>inactive</em>.
* Depending on it's state, a layer can behave differently.
    * For center layers you can specify its rotation speed, rotation mode, colorization and scale.
    * For slice layers you can specify its colorization, opacity and scale.


##2. Draw the necessary images

This can be done with the image manipulating application of your choice. For svg's this probably will be <a href="http://inkscape.org/">Inkscape</a>, if you decide to use another image format, the <a href="http://www.gimp.org/">Gimp</a> may be a good choice. I won't get into detail how to draw those images, but I'll post the images used for an old version of the theme "Adwaita" as an example.

<p>
<div class="row magnific-gallery">
    <div class="col-xs-3">
        {% assign picture = "icon_inactive.svg_.jpg" %}
        {% assign size = "small" %}
        {% assign text = "icon_inactive.svg" %}
        {% include gallery_item %}
    </div>
    <div class="col-xs-3">
        {% assign picture = "icon_active.svg_.jpg" %}
        {% assign size = "small" %}
        {% assign text = "icon_active.svg" %}
        {% include gallery_item %}
    </div>
    <div class="col-xs-3">
        {% assign picture = "ring.svg_.jpg" %}
        {% assign size = "small" %}
        {% assign text = "ring.svg" %}
        {% include gallery_item %}
    </div>
    <div class="col-xs-3">
        {% assign picture = "arrow.svg_.jpg" %}
        {% assign size = "small" %}
        {% assign text = "arrow.svg" %}
        {% include gallery_item %}
    </div>
</div>
</p>


##3. Create a theme.xml file

If you have your images, they need to be combined to one theme with an `theme.xml` file. Place all your images in the directory `~/.config/gnome-pie/themes/name_of_your_theme`. You may have to create this directory if it doesn't exist. Then create a new file in this directory called `theme.xml`.

The basic structure of this XML document is as follows:

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>

<theme>
    <pie>
        <center>
            <center_layer />
            ...
        </center>
        <slices>
            <activeSlice>
                <slice_layer />
                ...
            </activeSlice>
            <inactiveSlice>
                <slice_layer />
                ...
            </inactiveSlice>
        </slices>
        <caption />
    </pie>
</theme>
{% endhighlight %}

Remember, there can be an arbitrary amount of layers! The order of the layers in the XML file specifies how they are painted on top of each other. The first layer will be the bottom-most, succeeding layers will be painted on by one on to each other.

The most basic, working theme without any images looks like that. Maybe you can use this as a base and start experimenting!

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>

<theme name="Simple" description="The simplest theme" author="Simon Schneegans" email="code@simonschneegans.de">
    <pie>
        <center>
        </center>
        <slices>
            <activeSlice>
                <slice_layer type="icon" />
            </activeSlice>
            <inactiveSlice>
                <slice_layer type="icon" />
            </inactiveSlice>
        </slices>
        <caption />
    </pie>
</theme>
{% endhighlight %}

For each element there are some attributes which can be specified. Not all of them are necessary, the following is a complete list as reference. On the right side there is the default value. Each element with a default value is optional, all others are marked as mandatory.

###The &lt;theme&gt; element
<table>
<thead>
    <tr><th><h4>Element</h4></th><th class="pull-right"><h4>Default value</h4></th></tr>
</thead>
<tbody>
    <tr><td><strong>author</strong><br><small>Your name </small></td><td class="pull-right">mandatory </td></tr>
    <tr><td><strong>description</strong><br><small>Description of the theme </small></td><td class="pull-right">mandatory </td></tr>
    <tr><td><strong>email</strong><br><small>Your e-mail address </small></td><td class="pull-right">mandatory </td></tr>
    <tr><td><strong>name</strong><br><small>Name of the theme </small></td><td class="pull-right">mandatory </td></tr>
</tbody>
</table>

###The &lt;pie&gt; element
<table>
<thead>
    <tr><th><h4>Element</h4></th><th class="pull-right"><h4>Default value</h4></th></tr>
</thead>
<tbody>
    <tr><td><strong>fadeInRotation</strong><br><small>Initial rotation when opening a pie </small></td><td class="pull-right">0.0 </td></tr>
    <tr><td><strong>fadeInTime</strong><br><small>Time for opening animation </small></td><td class="pull-right">0.2 </td></tr>
    <tr><td><strong>fadeInZoom</strong><br><small>Initial zoom-factor when opening a pie </small></td><td class="pull-right">1.0 </td></tr>
    <tr><td><strong>fadeOutRotation</strong><br><small>Final rotation when closing a pie </small></td><td class="pull-right">0.0 </td></tr>
    <tr><td><strong>fadeOutTime</strong><br><small>Time for closing animation </small></td><td class="pull-right">0.1 </td></tr>
    <tr><td><strong>fadeOutZoom</strong><br><small>Final zoom-factor when closing a pie </small></td><td class="pull-right">1.0 </td></tr>
    <tr><td><strong>maxZoom</strong><br><small>Zoom factor for hovered slices </small></td><td class="pull-right">1.2 </td></tr>
    <tr><td><strong>radius</strong><br><small>Radius of the pie in pixels </small></td><td class="pull-right">150.0 </td></tr>
    <tr><td><strong>springiness</strong><br><small>Bouncy-ness of all animations </small></td><td class="pull-right">0.0 </td></tr>
    <tr><td><strong>transitionTime</strong><br><small>Global animation speed </small></td><td class="pull-right">0.5 </td></tr>
    <tr><td><strong>wobble</strong><br><small>Amount of slice distortion </small></td><td class="pull-right">0.0 </td></tr>
    <tr><td><strong>zoomRange</strong><br><small>Area around the hovered slice which is zoomed </small></td><td class="pull-right"> 0.2 </td></tr>
</tbody>
</table>

###The &lt;center&gt; element
<table>
<thead>
    <tr><th><h4>Element</h4></th><th class="pull-right"><h4>Default value</h4></th></tr>
</thead>
<tbody>
    <tr><td><strong>activeRadius</strong><br><small>Radius until the center becomes active </small></td><td class="pull-right">45.0 </td></tr>
    <tr><td><strong>radius</strong><br><small>Radius of the center in pixels </small></td><td class="pull-right">90.0 </td></tr>
</tbody>
</table>

###The &lt;center_layer&gt; element
<table>
<thead>
    <tr><th><h4>Element</h4></th><th class="pull-right"><h4>Default value</h4></th></tr>
</thead>
<tbody>
    <tr><td><strong>[in]active_alpha</strong><br><small>Opacity of this layer </small></td><td class="pull-right">1.0 </td></tr>
    <tr><td><strong>[in]active_colorize</strong><br><small>Whether this layer should be colored according to the currently active slice </small></td><td class="pull-right"> false </td></tr>
    <tr><td><strong>[in]active_rotationMode</strong><br><small>Possible values: <strong>auto</strong> (turns endlessly around), <strong>turn_to_active</strong> (the image is rotated so it faces with its right side the currently active slice), <strong>turn_to_mouse</strong> (the image is rotated so it faces with its right side the mouse)</small></td><td class="pull-right">auto </td></tr>
    <tr><td><strong>[in]active_rotationSpeed</strong><br><small>The speed of any rotation of this layer </small></td><td class="pull-right"> 0.0 </td></tr>
    <tr><td><strong>[in]active_scale</strong><br><small>Scale factor of this layer </small></td><td class="pull-right">1.0 </td></tr>
    <tr><td><strong>file</strong><br><small>Image file used for this layer </small></td><td class="pull-right">mandatory </td></tr>
</tbody>
</table>

###The &lt;slices&gt; element
<table>
<thead>
    <tr><th><h4>Element</h4></th><th class="pull-right"><h4>Default value</h4></th></tr>
</thead>
<tbody>
    <tr><td><strong>minGap</strong><br><small>If the gap between adjacent slices becomes to narrow (due to the pie being full of slices) the entire pie will expand</small></td><td class="pull-right">14.0 </td></tr>
    <tr><td><strong>radius</strong><br><small>Radius of a slice in pixels </small></td><td class="pull-right">150.0 </td></tr>
</tbody>
</table>

###The &lt;slice_layer&gt; element
<table>
<thead>
    <tr><th><h4>Element</h4></th><th class="pull-right"><h4>Default value</h4></th></tr>
</thead>
<tbody>
    <tr><td><strong>colorize</strong><br><small>Whether this layer gets colorized according to the icon of this slice </small></td><td class="pull-right">false</td></tr>
    <tr><td><strong>file</strong><br><small>If type is file: the image file to use, is type is icon: a mask - the icon will be visible at the non-transparent parts of this image </small></td><td class="pull-right"> mandatory if type="file" </td></tr>
    <tr><td><strong>scale</strong><br><small>Scale of this layer </small></td><td class="pull-right">1.0 </td></tr>
    <tr><td><strong>visibility</strong><br><small>Can be set either to with_caption, without_caption or to any. The layer will be shown or hidden according to caption visibility selected in the user's preferences.</small></td><td class="pull-right">any</td></tr>
    <tr><td><strong>type</strong><br><small>Type of this slice layer, can be one of the following: file (an image file), icon (the actual icon of the slice is placed at this level of slice) or caption (the name of the slice will be written here)</small></td><td class="pull-right"> file</td></tr>
    <tr><td><strong>x</strong><br><small>Horizontal position offset of the layer </small></td><td class="pull-right"> 0.0 </td></tr>
    <tr><td><strong>y</strong><br><small>Vertical position offset of the layer </small></td><td class="pull-right"> 0.0 </td></tr>
    <tr><td><strong>color</strong><br><small>Only for type caption: Color of the font </small></td><td class="pull-right">#FFFFFF </td></tr>
    <tr><td><strong>font</strong><br><small>Only for type caption: Font of the caption </small></td><td class="pull-right">sans 12 </td></tr>
    <tr><td><strong>height</strong><br><small>Only for type caption: Maximum height </small></td><td class="pull-right">100 </td></tr>
    <tr><td><strong>width</strong><br><small>Only for type caption: Maximum width </small></td><td class="pull-right">100 </td></tr>
</tbody>
</table>


##4. Post a screenshot in the comments

<p>
<div class="row magnific-gallery">
    <div class="col-xs-3">
        {% assign picture = "gnome-pie_adwaita.jpg" %}
        {% assign size = "small" %}
        {% assign text = "The Adwaita theme." %}
        {% include gallery_item %}
    </div>
    <div class="col-xs-3">
        {% assign picture = "gnome-pie_glossy.jpg" %}
        {% assign size = "small" %}
        {% assign text = "The glossy theme." %}
        {% include gallery_item %}
    </div>
    <div class="col-xs-3">
        {% assign picture = "gnome-pie_opie.jpg" %}
        {% assign size = "small" %}
        {% assign text = "The O-Pie theme." %}
        {% include gallery_item %}
    </div>
    <div class="col-xs-3">
        {% assign picture = "gnome-pie_unity.jpg" %}
        {% assign size = "small" %}
        {% assign text = "The Unity theme." %}
        {% include gallery_item %}
    </div>
</div>
</p>

If you created a theme you're happy with, share it! Please post a screenshot or the entire theme in the comments! I'm very pleased to include new themes in future releases of Gnome-Pie!

Happy theming!
