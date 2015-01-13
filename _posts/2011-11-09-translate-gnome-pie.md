---
layout: post
title: "Translate Gnome-Pie!"
tagline: "a step-by-step guide"
category: lessons
teaser: "translate.jpg"
tags: ["featured"]
---

It would be really cool if you could create a translation of Gnome-Pie into your language! It is quite easy and involves the following steps.

<!--more-->

All you need is the source code of Gnome-Pie and the locale string for your language. You can get the source code with the terminal command

{% highlight bash %}
git clone git://github.com/Simmesimme/Gnome-Pie.git
{% endhighlight %}

Your current locale can be obtained with

{% highlight bash %}
echo $LANG
{% endhighlight %}

## CREATING A NEW TRANSLATION

A translation of Gnome-Pie is done by editing a *.po file. This has to be generated first. Just follow the four steps below.

<ol>
    <li> Update the gnomepie.pot file:
    <ul>
        <li>Navigate with a terminal to the directory <code>resources/locale</code> inside of the source directory of Gnome-pie.</li>
        <li>Then enter the command <code>./gen-pot.sh</code> to create an updated template file.</li>
    </ul>
    </li>
    <li> Create your translation file:
    <ul>
        <li>Still being in this directory enter the command <code>./gen-po.sh</code>.</li>
        <li>Follow the instructions displayed in your terminal. You will have to insert your locale from above. You can also use a more general version of your locale, e.g. <code>de</code> instead of <code>de-DE.UTF8</code>.</li>
    </ul>
    </li>
    <li> Translate to your language:
    <ul>
        <li>The steps above created an translation file. Open the file <code>resources/locale/[your locale]/ LC_MESSAGES/[your locale].po</code> with your favorite text editor.</li>
        <li>Now create translations for every string in this file. There is the English string for each sentence in Gnome-Pie. Put your translation just beneath it in the empty <code>""</code>.</li>
    </ul>
    </li>
    <li> Compile translations:
    <ul>
        <li>Enter the command <code>./compile-po.sh</code>. When you now launch Gnome-Pie it should display in your language! If you installed it globally, you will have to copy the the file <code>resources/locale/[your locale]/LC_MESSAGES/gnomepie.mo</code> to <code>/usr/share/locale/[your locale]/LC_MESSAGES/gnomepie.mo</code> before.</li>
    </ul>
    </li>
</ol>


## UPDATING AN EXISTENT TRANSLATION

Updating a language which already has been translated is easy as well. Just follow the steps below.

<ol>
    <li> Update the gnomepie.pot file:
    <ul>
        <li>Navigate with a terminal to the directory <code>resources/locale</code> inside of the source directory of Gnome-pie.</li>
        <li>Then enter the command <code>./gen-pot.sh</code> to create an updated template file.</li>
    </ul>
    </li>
    <li> Update the translation file:
    <ul>
        <li>Still being in this directory enter the command <code>./update-po.sh</code>.</li>
        <li>Follow the instructions displayed in your terminal. You will have to insert the locale you want to update.</li>
    </ul>
    </li>
    <li> Translate to your language:
    <ul>
        <li>The steps above updated the content of the translation file. Open the file <code>resources/locale/[your locale]/ LC_MESSAGES/[your locale].po</code> with your favorite text editor.</li>
        <li>Now create translations for every string in this file which does not already have a translation. There is the English string for each sentence in Gnome-Pie. Put your translation just beneath it in the empty <code>"</code>.</li>
    </ul>
    </li>
    <li> Compile translations:
    <ul>
        <li>Enter the command <code>./compile-po.sh</code>. When you now launch Gnome-Pie it should display in your language! If you installed it globally, you will have to copy the the file <code>resources/locale/[your locale]/LC_MESSAGES/gnomepie.mo</code> to ´/usr/share/locale/[your locale]/LC_MESSAGES/gnomepie.mo</code> before.</li>
    </ul>
    </li>
</ol>

When this has been done you're ready to send the updated translation file to code[at]simonschneegans.de! I'm looking forward to many translations!
