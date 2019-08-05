---
layout: header-page
title : Theme Gallery
excerpt: "This is a list of Gnome-Pie themes I am aware of. You can download several themes here! If you discovered or created a new theme and want this theme to be added to the gallery, just send a link to <a href='mailto:code@simonschneegans.de'>code@simonschneegans.de</a> or drop a note in the commment section of the <a href='news/2016/07/17/gnome-pie-themes'>announcement post</a>!"
teaser: "gnome-pie065.jpg"
colors: "color-gnome-pie065"
parents: ["Gnome-Pie"]
---

<div class="row">
  {% for theme in site.data.themes %}
  <div class="col xl4 l6 m6 s12">
    <div class="gallery-item">
      {% assign picture = theme.preview %}
      {% assign text = theme.name %}
      {% include image.html %}
      <div class="caption">
        <h1>
          {{ theme.name }}
        </h1>
        <p>
          {% if theme.standard == "false" %}
            {{ theme.name }} is a theme by
            {% if theme.link == "false" %}
              {{ theme.author }}.
            {% else %}
              <a href="{{ theme.link }}" target="_blank">{{ theme.author }}</a>.
            {% endif %}
            You can <a href="/assets/files/gnome-pie-themes/{{ theme.file }}">download it here</a>!
          {% else %}
            {{ theme.name }} is included in every installation of Gnome-Pie.
          {% endif %}
        </p>
      </div>
    </div>
  </div>
  {% endfor %}
</div>
