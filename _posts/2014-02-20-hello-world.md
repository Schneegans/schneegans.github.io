---
layout: post
title: "Hello World"
description: "huhu"
published: true
category: lesson
comments: true
tags: [test]
---
{% include JB/setup %}

## Test

{{ page.excerpt | textilize }}

{{ site.time | date_to_string }}

I really like working on Gnome-Pie --- and you can help improving it! There are many people sending mails to me, praising the possibilities Gnome-Pie offers to them. But I think it can be even better! Let's try to improve this piece of software together! There are multiple things you can do in order to become a part of Gnome-Pie's history:

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
///////////////////////////////////////////////////////////////
/// Some cool method.
///////////////////////////////////////////////////////////////

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


