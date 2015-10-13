---
layout: post
title: "Color Splash!"
tagline: "new adaptive link colors!"
category: news
teaser: "color_splash.jpg"
colors: "color-color_splash"
description: "That happens if you combine thirty seconds of exposure, a mobile phone and someone jumping around wildly."
tags: ["jekyll", "code"]
---

I added a nifty feature to my homepage: Links are now colored according to corresponding images!

<!--more-->

## What's new?

Every link on this homepage is now colored based on the dominant color of a related image. Blog posts for example take the primary color from their teaser image. Links on the [blog roll](/blog) are colored according to the teaser image of the posts they link to. Some other pages such as the [home page](/) or the [projects page](/projects.html) use a custom default color.

You can use the navigation links on the bottom of this page to jump through the older posts in chronological order. I really like how each post has its own color scheme now! Even the Discuss comments are tinted according to the header picture.

## How does it work?

I wrote a little [Vala](https://wiki.gnome.org/Projects/Vala) program called "color_extractor" which is automatically executed when I upload this website to github. The source code of the color_extractor is available [here](https://github.com/Simmesimme/Simmesimme.github.io/tree/master/_color_extractor). This program extracts a dominant color from [each picture](https://github.com/Simmesimme/Simmesimme.github.io/tree/master/assets/pictures) used on this website. It stores the colors in a file as a sass map. This file looks like this:

{% highlight sass %}
$link-colors: (
  color-fallback: #FF917F,
  color-translate2: #FF767F,
  color-alchemy2: #FF7F7F,
  color-gnome-pie_24: #FF7F92,
  color-gnome-pie_adwaita: #7AB1FF,
  color-simon: #FF917F,
  color-trace_paths: #7FFF7F,
  color-bird: #FFD67F,
  color-gnome-pie_unity: #FF7FA1,
  color-project-hzb: #7FC6FF,
  color-install: #7FCCFF,
  color-sun: #FF8F31,
  color-moss: #BCFF35,
  color-teaser-art: #FF8837,
  color-gnome-pie_04: #FF987F,
  color-project-artwork: #FF987C,
  color-gnome-pie063: #7FB6FF,
  color-gnome-pie_12: #FF737E,
  color-gnome-pie_06: #FFC97F,
  color-bachelor09: #EAFF7F,
  color-witch: #FFD67F,
  ...
);
{% endhighlight %}


This sass map is included in my main.scss file and with some loops converted into several css classes. Finally, I only have to specify the color which should be used by the entire page in the front matter of each post or page. For example:


{% highlight yaml %}
---
colors: color-fallback
---
{% endhighlight %}

Then this will be written as a class into the body tag of each page:

{% highlight html %}
<body class="{{ "{{ page.colors " }}}}">
...
</body>
{% endhighlight %}

On the blog roll page where each post is colored differently, the class is assigned to each post preview container:


{% highlight html %}

{{ "{% for post in paginator.posts " }}%}
<div class="post-preview {{ "{{ post.colors " }}}}">
...
</div>
{{ "{% endfor " }}%}

{% endhighlight %}

I am very happy with the results. This system provides automatically static html pages which all have individual link colors. No JavaScript is required! If you want to know more details, feel free to ask!
