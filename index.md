---
layout: page
title: Hello World!
tagline: Supporting tagline
---
{% include JB/setup %}

<ul class='kwicks kwicks-horizontal'>
    <li id="panel-1">
      <div class="description">
      <h2>Test Heading</h2>
      Lorem ipsum dolor sit amet, consectetur adipisicing elit. Perferendis rem maxime consequatur necessitatibus dolorem, nesciunt dolores. Culpa rem temporibus nihil voluptatibus, doloremque totam, eligendi dicta, veniam optio distinctio, debitis enim. </div>
      <div class="bg" style="background-image:url('{{ site.url }}/assets/pictures/header01.jpg')"></div>
    </li>
    <li id="panel-2">
      <div class="description">
      <h2>Test Heading</h2>
      Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quae blanditiis excepturi eius a doloribus voluptas dolore deleniti alias laboriosam asperiores laborum aliquid amet laudantium nobis, sint enim suscipit autem voluptates! </div>
      <div class="bg" style="background-image:url('{{ site.url }}/assets/pictures/header02.jpg')"></div>
    </li>
    <li id="panel-3">
      <div class="description">
      <h2>Test Heading</h2>
      Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ad alias molestias velit facilis quam provident veniam quo quis dolores, possimus necessitatibus delectus esse, quidem fuga cumque itaque, harum sint earum! </div>
      <div class="bg" style="background-image:url('{{ site.url }}/assets/pictures/header03.jpg')"></div>
    </li>
    <li id="panel-4">
      <div class="description">
      <h2>Test Heading</h2>
      Lorem ipsum dolor sit amet, consectetur adipisicing elit. Inventore eveniet reiciendis recusandae possimus accusamus fugit similique, tempora magnam minima, molestias dicta rerum earum perspiciatis molestiae soluta magni. Voluptatem, officia, necessitatibus. </div>
      <div class="bg" style="background-image:url('{{ site.url }}/assets/pictures/header04.jpg')"></div>
    </li>
</ul>



<div class="row">
  <div class="span6">

    <h2>latest projects</h2>

    <ul class="sub-nav">
      {% assign pages_list = site.pages %}
      {% assign group = 'projects' %}
      {% include JB/pages_list %}
    </ul>

  </div>
  <div class="span6">
    <h2>latest posts</h2>

    <ul class="sub-nav">
      {% for post in site.posts %}
        <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
      {% endfor %}
    </ul>

  </div>
</div>



