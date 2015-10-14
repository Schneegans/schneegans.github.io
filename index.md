---
layout: page
title: Projects and Blog
description: "Homepage of Simon Schneegans. Here you will find news related to Gnome-Pie, M.A.R.S.2 and other projects of mine."
colors: color-fallback
---



<!-- <nav class="row">
 <div class="text-center col-sm-6 sub-nav">
    <h2><i class="fa fa-gears"></i> latest projects</h2>
    <small>find on the <a href="/projects.html">projects page</a></small>
    <hr>
    <ul>
        <li><a href="/gnome-pie.html">Gnome-Pie</a><br></li>
        <li><a href="/mars.html">M.A.R.S.</a><br></li>
        <li><a href="/formes-et-couleurs.html">Stop Motion</a><br></li>
    </ul>
  </div>
  <div class="text-center col-sm-6 sub-nav">
    <h2><i class="fa fa-pencil"></i> latest posts</h2>
    <small>read more on my <a href="/blog">blog page</a></small>
    <hr>
    <ul>
      {% for post in site.posts limit: 3 %}
        <li><a href="{{ post.url }}">{{ post.title }}</a><br></li>
      {% endfor %}
    </ul>
  </div>
</nav> -->

<div class="accordion accordion-items-4">
  <ul>
    <li class="color-teaser-gnomepie" style="background-image:url('/assets/pictures/teaser-gnomepie.jpg')">
      <div>
        <h2>Gnome-Pie</h2>
        <p>Gnome-Pie is a slick application launcher for Linux. It’s eye candy and pretty fun to work with. It offers multiple ways to improve your desktop experience. <br><a href="/gnome-pie.html">Gnome-Pie's homepage <i class="fa fa-angle-right"></i></a></p>
      </div>
    </li>
    <li class="color-project-gnomepie" style="background-image:url('/assets/pictures/teaser-mars.jpg')">
      <div>
        <h2>M.A.R.S. - a ridiculous shooter</h2>
        <p>M.A.R.S. is a ridiculous, open source 2D shooter. It is a game for two players, flying with ships in a two-dimensional space setting, governed by the laws of gravity. <br> <a href="/mars.html">watch the trailer <i class="fa fa-angle-right"></i></a></p>
      </div>
    </li>
    <li class="color-lfelc-planning" style="background-image:url('/assets/pictures/teaser-formes-et-couleurs.jpg')">
      <div>
        <h2>Stop motion clip</h2>
        <p>Some time ago, I created in a team of two a stop motion clip for a computer animation class. It features 927 frames shot with a Canon EOS 450d. <br> <a href="/formes-et-couleurs.html">watch the video <i class="fa fa-angle-right"></i></a></p>
      </div>
    </li>
    <li class="color-teaser-art" style="background-image:url('/assets/pictures/london.jpg')">
      <div>
        <h2>Random artwork</h2>
        <p>When I'm not currently working on a software project, I take photographs or use open source software to draw images. Here's a collection of various images I've drawn with no real purpose.<br> <a href="/artwork.html">view the artwork <i class="fa fa-angle-right"></i></a></p>
      </div>
    </li>
  </ul>
</div>


<nav class="row">
  <div class="text-center col-xs-8 col-xs-offset-2">
    <br><br><hr><br>
  </div>
  <div class="text-center col-xs-12">
    Greetings!<br>Explore the <a href="/blog"><i class="fa fa-pencil"></i> blog</a>, discover my <a href="/projects.html"><i class="fa fa-gears"></i> projects</a> or use the <i class="fa fa-tag"></i> tags below to find something specific.
  </div>
  <div class="text-center col-xs-8 col-xs-offset-2">
    <br><hr><br>
  </div>
  <div class="text-center col-sm-6 col-sm-offset-3 col-xs-8 col-xs-offset-2">
    <!-- <h2></h2> -->
    {% for tag in site.tags %}
    <a href="/blog/tags/{{ tag | first | slugize }}" class="badge" style="font-size: {{ tag | last | size | times: 50 | divided_by: site.tags.size | plus: 70 }}%">
      {{ tag | first }}
    </a>
    {% endfor %}
  </div>
</nav>
<br><br><br>
