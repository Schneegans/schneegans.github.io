---
layout: page
title: Hello World!
tagline: Supporting tagline
---
{% include JB/setup %}

<ul class='kwicks kwicks-horizontal'>
    <li id="panel-1">
      <div class="description">
      <h2>GNOME-PIE</h2>
      Gnome-Pie a slick application launcher for Linux. It’s eye candy and pretty fun to work with. It offers multiple ways to improve your desktop experience.</div>
      <div class="bg" style="background-image:url('{{ site.url }}/assets/pictures/teaser-gnomepie.jpg')"></div>
    </li>
    <li id="panel-2">
      <div class="description">
      <h2>Test Heading</h2>
      Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quae blanditiis excepturi eius a doloribus voluptas dolore deleniti alias laboriosam asperiores laborum aliquid amet laudantium nobis, sint enim suscipit autem voluptates! </div>
      <div class="bg" style="background-image:url('{{ site.url }}/assets/pictures/header02.jpg')"></div>
    </li>
    <li id="panel-3">
      <div class="description">
      <h2>Les Formes et les Couleurs</h2>
      It is short &amp; funny old-school stop motion video created together with a friend of mine. It feauters 927 frames shot with a Canon EOS 450d.</div>
      <div class="bg" style="background-image:url('{{ site.url }}/assets/pictures/teaser-formes-et-couleurs.jpg')"></div>
    </li>
    <li id="panel-4">
      <div class="description">
      <h2>Test Heading</h2>
      Lorem ipsum dolor sit amet, consectetur adipisicing elit. Inventore eveniet reiciendis recusandae possimus accusamus fugit similique, tempora magnam minima, molestias dicta rerum earum perspiciatis molestiae soluta magni. Voluptatem, officia, necessitatibus. </div>
      <div class="bg" style="background-image:url('{{ site.url }}/assets/pictures/header04.jpg')"></div>
    </li>
</ul>



<div class="row">
  <div class="span4">

    <h2>latest projects</h2>

    <ul class="sub-nav">
        <hr/>
      {% for page in site.pages %}
      {% if page.group == "featured-project" %}
        <li><a href="{{ BASE_PATH }}{{ page.url }}">{{ page.title }}</a></li>
        <hr/>
      {% endif %}
      {% endfor %}
    </ul>

  </div>
  <div class="span4">
    <h2>featured posts</h2>

    <ul class="sub-nav">
        <hr/>
      {% assign post_count = 0 %}

      {% for post in site.posts %}
        {% if post.tags contains "featured" %}
          <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
          <hr/>
          {% assign post_count=post_count | plus:1 %}
          {% if post_count == 3 %}
            {% break %}
          {% endif %}
        {% endif %}
      {% endfor %}
    </ul>

  </div>
  <div class="span4">
    <h2>latest posts</h2>

    <ul class="sub-nav">
        <hr/>
      {% assign post_count = 0 %}

      {% for post in site.posts %}
        <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
        <hr/>
        {% assign post_count=post_count | plus:1 %}
        {% if post_count == 3 %}
          {% break %}
        {% endif %}
      {% endfor %}
    </ul>

  </div>
</div>



