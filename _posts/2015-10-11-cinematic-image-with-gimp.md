---
layout: post
title: "Create a cinematic image!"
tagline: "enhance your boring photos with the gimp."
category: tutorials
teaser: "london.jpg"
colors: "color-london_01"
description: "You can quickly turn your dull pictures to awesome shots like this."
tags: ["tutorial", "gimp", "artwork"]
---

You were on holidays and all your pictures look a little... dull? Maybe this quick tutorial will give you some inspiration!

<!--more-->

Last weekend I was at the [London Eye](https://www.londoneye.com/){:target="_blank"} and took the following photograph. It features an interseting view at the Shard but it looks quite boring. So I decided to use my favourite image manipulation program, [the gimp](http://www.gimp.org/){:target="_blank"}, to enhance the picture.

{% assign picture = "london_01.jpg" %}
{% assign size = "large" %}
{% assign text = "A cool perspective but boring colors." %}
{% include image %}


## Improving the white balance

At first, I improved the white balance. There is a lot of haze in this picture and a bit of contrast will serve well. So I chose `Colors > Auto > White Balance`. The result is below. It looks much crispier! Move your mouse over the image below to explore the differences!

{% assign picture_a = "london_01.jpg" %}
{% assign picture_b = "london_02.jpg" %}
{% assign size = "large" %}
{% include before_after_image %}

## Replace the sky

Since the blue sky of the original image is a little plain, I [searched the internet](https://www.google.com/search?q=sunrise+sky&source=lnms&tbm=isch&sa=X#q=sunrise+sky&tbm=isch&tbs=sur:fc){:target="_blank"} for a better sky. Eventually I found [this image](http://i.imgur.com/947A6za.jpg){:target="_blank"}. It's very beautiful and I really would like to credit its original author but I failed to find his or her name.

I deleted the sky from the original image with the eraser tool and pasted the new sky to a new layer below the original image.

<p>
    <div class="row magnific-gallery">
        <div class="col-xs-6">
            {% assign picture = "london_03.jpg" %}
            {% assign size = "medium" %}
            {% assign text = "The old sky was boring." %}
            {% include gallery_item %}
        </div>
        <div class="col-xs-6">
            {% assign picture = "london_04.jpg" %}
            {% assign size = "medium" %}
            {% assign text = "The new sky is much more awesome." %}
            {% include gallery_item %}
        </div>
    </div>
</p>

{% assign picture_a = "london_02.jpg" %}
{% assign picture_b = "london_05.jpg" %}
{% assign size = "large" %}
{% include before_after_image %}

## Color grading of the foreground

The picture looks quite interesting, but we need to adjust the colors of the skyline. Therefore I duplicated the skyline layer and tinted the copy to some warm orange with `Colors > Colorize...`. Then I deleted most of the tinted version; only on the right hand side where the sun is supposed to be I kept the orange version.

<p>
    <div class="row magnific-gallery">
        <div class="col-xs-6">
            {% assign picture = "london_06.jpg" %}
            {% assign size = "medium" %}
            {% assign text = "The tinted skyline layer." %}
            {% include gallery_item %}
        </div>
        <div class="col-xs-6">
            {% assign picture = "london_07.jpg" %}
            {% assign size = "medium" %}
            {% assign text = "Most of the tinted skyline layer has been erased." %}
            {% include gallery_item %}
        </div>
    </div>
</p>

{% assign picture_a = "london_05.jpg" %}
{% assign picture_b = "london_08.jpg" %}
{% assign size = "large" %}
{% include before_after_image %}

## The sun glare

Finally I used some additional sunrise images to add a sun glare to the image. I used [this CC by SA image by Zimmermanns](https://commons.wikimedia.org/wiki/File:Sunrise_above_Oberwiesenthal.JPG){:target="_blank"} and [this public domain image](http://www.public-domain-image.com/free-images/nature-landscapes/sunrise/beautiful-sunrise-over-volcanoes-in-guatemala/attachment/beautiful-sunrise-over-volcanoes-in-guatemala){:target="_blank"}. I put both on separate layers, moved them around, blurred, mirrored and erased some parts. Both blend modes were set to `Soft Light`.

<p>
    <div class="row magnific-gallery">
        <div class="col-xs-6">
            {% assign picture = "london_09.jpg" %}
            {% assign size = "medium" %}
            {% assign text = "A subtle glare." %}
            {% include gallery_item %}
        </div>
        <div class="col-xs-6">
            {% assign picture = "london_10.jpg" %}
            {% assign size = "medium" %}
            {% assign text = "Some glare over the skyline." %}
            {% include gallery_item %}
        </div>
    </div>
</p>

{% assign picture_a = "london_08.jpg" %}
{% assign picture_b = "london.jpg" %}
{% assign size = "large" %}
{% include before_after_image %}

## Final comparison

That's it! You can [download the full resolution result here](/assets/pictures/london.jpg){:target="_blank"}. Below you can check the differences between the original photo and the final version. Please post a link in the comments if you created some cool images with a similar technique!

{% assign picture_a = "london_01.jpg" %}
{% assign picture_b = "london.jpg" %}
{% assign size = "large" %}
{% include before_after_image %}
