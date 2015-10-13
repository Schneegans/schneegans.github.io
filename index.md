---
layout: page
title: Projects and Blog
description: "Homepage of Simon Schneegans. Here you will find news related to Gnome-Pie, M.A.R.S.2 and other projects of mine."
colors: color-fallback
---




<nav class="row">
  <div class="text-center col-sm-4 sub-nav">
    <h2>latest projects</h2>
    <hr>
    <ul>
        <li><a href="/gnome-pie.html">Gnome-Pie</a><br></li>
        <li><a href="/mars.html">M.A.R.S.</a><br></li>
        <li><a href="/formes-et-couleurs.html">Stop Motion</a><br></li>
        <li><a href="/artwork.html">Random Artwork</a><br></li>
    </ul>
  </div>
  <div class="text-center col-sm-4">
    <h2>tags</h2>
    <hr>
    {% for tag in site.tags %}
    <a href="/blog/tags/{{ tag | first | slugize }}" class="badge" style="font-size: {{ tag | last | size | times: 50 | divided_by: site.tags.size | plus: 70 }}%">
      {{ tag | first }}
    </a>
    {% endfor %}
  </div>
  <div class="text-center col-sm-4 sub-nav">
    <h2>latest posts</h2>
    <hr>
    <ul>
      {% for post in site.posts limit: 4 %}
        <li><a href="{{ post.url }}">{{ post.title }}</a><br></li>
      {% endfor %}
    </ul>
  </div>

</nav>

