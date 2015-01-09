---
layout: page
title: Hello World!
tagline: Supporting tagline
---
{% include JB/setup %}



![My helpful screenshot]({{ site.url }}/assets/pictures/mars.jpg)


<div class="row">
  <div class="span6">

    <h2>lastest projects</h2>

    <ul class="posts">
      {% assign pages_list = site.pages %}
      {% assign group = 'projects' %}
      {% include JB/pages_list %}
    </ul>

  </div>
  <div class="span6">
    <h2>lastest posts</h2>

    <ul class="posts">
      {% for post in site.posts %}
        <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
      {% endfor %}
    </ul>

  </div>
</div>



