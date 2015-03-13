---
layout: page
title: Hello World!
description: "Homepage of Simon Schneegans. Here you will find news related to Gnome-Pie, M.A.R.S.2 and other projects of mine."
---

<ul class='kwicks kwicks-horizontal'>
    <li id="panel-1">

      <div class="description">
      <h2><a href="/gnome-pie.html">Gnome-Pie</a></h2>
      Gnome-Pie a slick application launcher for Linux. It’s eye candy and pretty fun to work with. It offers multiple ways to improve your desktop experience.</div>
      <div class="bg" style="background-image:url('/assets/pictures/teaser-gnomepie.jpg')"></div>
    </li>
    <li id="panel-2">
      <div class="description">
      <h2><a href="/mars.html">M.A.R.S. - a ridiculous shooter</a></h2>
      M.A.R.S. is a ridiculous, open source 2D shooter. It is a game for two players, flying with ships in a two-dimensional space setting, governed by the laws of gravity.</div>
      <div class="bg" style="background-image:url('/assets/pictures/teaser-mars.jpg')"></div>
    </li>
    <li id="panel-3">
      <div class="description">
      <h2><a href="/artwork.html">Random artwork</a></h2>
      When I'm not currently working on a software project, I use open source software to draw images. Here's a collection of various images I've drawn with no real purpose. Most of them are done with Blender, MyPaint, Alchemy and The Gimp.
      </div>
      <div class="bg" style="background-image:url('/assets/pictures/knife.jpg')"></div>
    </li>
    <li id="panel-4">
      <div class="description">
      <h2><a href="/formes-et-couleurs.html">Les Formes et les Couleurs</a></h2>
      It is short &amp; funny old-school stop motion video created together with a friend of mine. It features 927 frames shot with a Canon EOS 450d.</div>
      <div class="bg" style="background-image:url('/assets/pictures/teaser-formes-et-couleurs.jpg')"></div>
    </li>
</ul>



<nav class="row">
  <div class="col-sm-4 sub-nav">
    <h2>latest projects</h2>
    <hr>
    <ul>
      {% for page in site.pages %}
      {% if page.group == "featured-projects" %}
        <li><a href="{{ page.url }}">{{ page.title }}</a><hr></li>
      {% endif %}
      {% endfor %}
    </ul>

  </div>
  <div class="col-sm-4 sub-nav">
    <h2>featured posts</h2>
    <hr>
    <ul>
      {% assign post_count = 0 %}
      {% for post in site.posts %}
        {% if post.tags contains "featured" %}
          <li><a href="{{ post.url }}">{{ post.title }}</a><hr></li>
          {% assign post_count=post_count | plus:1 %}
          {% if post_count == 3 %}
            {% break %}
          {% endif %}
        {% endif %}
      {% endfor %}
    </ul>

  </div>
  <div class="col-sm-4 sub-nav">
    <h2>latest posts</h2>
    <hr>
    <ul>
      {% assign post_count = 0 %}
      {% for post in site.posts %}
        <li><a href="{{ post.url }}">{{ post.title }}</a><hr></li>
        {% assign post_count=post_count | plus:1 %}
        {% if post_count == 3 %}
          {% break %}
        {% endif %}
      {% endfor %}
    </ul>

  </div>
</nav>



