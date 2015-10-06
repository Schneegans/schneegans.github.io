---
layout: page
title: Projects and Blog
description: "Homepage of Simon Schneegans. Here you will find news related to Gnome-Pie, M.A.R.S.2 and other projects of mine."
colors: color-fallback
---

<div class="accordion accordion-items-4">
  <ul>
    <li class="color-gnome-pie065" style="background-image:url('/assets/pictures/teaser-gnomepie.jpg')">
      <div>
        <h2>Gnome-Pie</h2>
        <p>Gnome-Pie is a slick application launcher for Linux. It’s eye candy and pretty fun to work with. It offers multiple ways to improve your desktop experience. <br><a href="/gnome-pie.html">read on <i class="fa fa-angle-right"></i></a></p>
      </div>
    </li>
    <li class="color-project-gnomepie" style="background-image:url('/assets/pictures/teaser-mars.jpg')">
      <div>
        <h2>M.A.R.S. - a ridiculous shooter</h2>
        <p>M.A.R.S. is a ridiculous, open source 2D shooter. It is a game for two players, flying with ships in a two-dimensional space setting, governed by the laws of gravity. <br> <a href="/mars.html">read on <i class="fa fa-angle-right"></i></a></p>
      </div>
    </li>
    <li class="color-signals" style="background-image:url('/assets/pictures/signals.jpg')">
      <div>
        <h2>C++11 Signals and Slots</h2>
        <p>I've been asked multiple times how I would implement a signal / slot mechanism in modern C++. Here is the answer! <br> <a href="{% post_url 2015-09-20-signal-slot %}">read on <i class="fa fa-angle-right"></i></a></p>
      </div>
    </li>
    <li class="color-sunset" style="background-image:url('/assets/pictures/teaser-art.jpg')">
      <div>
        <h2>Random artwork</h2>
        <p>When I'm not currently working on a software project, I use open source software to draw images. Here's a collection of various images I've drawn with no real purpose. Most of them are done with Blender, MyPaint, Alchemy and The Gimp. <br> <a href="/artwork.html">read on <i class="fa fa-angle-right"></i></a></p>
      </div>
    </li>
  </ul>
</div>


<nav class="row">
  <div class="col-sm-4 sub-nav">
    <h2>navigation</h2>
    <hr>
    <ul>
        <li><a href="/blog">Blog / News</a><br></li>
        <li><a href="/projects.html">Projects</a><br></li>
        <li><a href="/about.html">About</a><br></li>
    </ul>
  </div>
  <div class="col-sm-4 sub-nav">
    <h2>latest posts</h2>
    <hr>
    <ul>
      {% assign post_count = 0 %}
      {% for post in site.posts %}
        <li><a href="{{ post.url }}">{{ post.title }}</a><br></li>
        {% assign post_count=post_count | plus:1 %}
        {% if post_count == 3 %}
          {% break %}
        {% endif %}
      {% endfor %}
    </ul>
  </div>
  <div class="col-sm-4 sub-nav">
    <h2>popular posts</h2>
    <hr>
    <ul>
      {% assign post_count = 0 %}
      {% for post in site.posts %}
        {% if post.tags contains "featured" %}
          <li><a href="{{ post.url }}">{{ post.title }}</a><br></li>
          {% assign post_count=post_count | plus:1 %}
          {% if post_count == 3 %}
            {% break %}
          {% endif %}
        {% endif %}
      {% endfor %}
    </ul>
  </div>
  <!-- <div class="col-sm-4 sub-nav">
    <h2>latest projects</h2>
    <hr>
    <ul>
      {% for page in site.pages %}
      {% if page.group == "featured-projects" %}
        <li><a href="{{ page.url }}">{{ page.title }}</a><br></li>
      {% endif %}
      {% endfor %}
    </ul>
  </div> -->
</nav>

