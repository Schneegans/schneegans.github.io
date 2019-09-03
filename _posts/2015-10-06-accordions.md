---
layout: post
title: "CSS3-only Accordions!"
category: tutorials
teaser: "accordions.jpg"
colors: "color-accordions"
license: "public domain"
tagline: "The accordion on my homepage uses CSS3 only. No JavaScript is required!"
tags: ["html5", "tutorial", "css3", "code"]
---

With this tutorial I will show you how I implemented the accordion on the project page of my website. It is based on CSS3, requires no JavaScript and is fully responsive.

<!--more-->

## Yet another accordion?

**Update: Scroll down to the end of the post for the final SASS code!**

There is one main advantage of the approach presented here over others I found on the internet: The slides truly overlap each other. This prevents ugly text reflow during the animation (as seen in [this prominent example](https://blogs.sitepointstatic.com/examples/tech/css3-target/accordionhorz.html){:target="_blank"}, [this one](https://csswizardry.com/demos/accordion/){:target="_blank"} or [this one](https://experiments.wemakesites.net/animated-css3-only-horizontal-accordion.html){:target="_blank"}) and allows for multiple lines of text in the captions (as opposed to [this example](https://codepen.io/ferry/pen/ZYVwxz){:target="_blank"}).

Furthermore the horizontal accordion presented here is fully responsive - no fixed width is required; it will always fill `100%` of its parent container (other accordions, such as [this one](https://thecodeplayer.com/walkthrough/make-an-accordian-style-slider-in-css3){:target="_blank"} or [this one](https://codepen.io/rrenula/pen/DGrhf){:target="_blank"} are hard-coded to a fixed width).

At first we will set up the basic behavior, then we will add background images and as a last step we will add captions. All style code will be provided as [SASS code](https://sass-lang.com/){:target="_blank"}.

## The basic bahavior

Here is the most basic version of the accordion. It has three items, each has a specific background color. If you hover over one slide it will expand, shrinking the others.

<div class="accordion accordion-items-3">
  <ul>
    <li style="background:#963C0C"></li>
    <li style="background:#086348"></li>
    <li style="background:#658D0B"></li>
  </ul>
</div>

{% highlight html %}
<div class="accordion">
  <ul>
    <li style="background:#963C0C"></li>
    <li style="background:#086348"></li>
    <li style="background:#658D0B"></li>
  </ul>
</div>
{% endhighlight %}

{% highlight scss %}
.accordion {

  ////////////////////////////////////////////////////////////
  // the first part of the style code is independent from   //
  // the number of slides in the accordion                  //
  ////////////////////////////////////////////////////////////

  // the accordion shall always have a fixed aspect ration in
  // order to prevent distortion. Therefore we set the height
  // to zero and define a bottom padding in percent. This is
  // done down in the second half.
  height: 0;

  position: relative;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 1);

  ul {
    margin: 0;
    padding: 0;

    // remove white space between slides
    font-size: 0;

    li {
      height: 0;
      margin: 0;
      padding: 0;
      display: inline-block;
      position: relative;
      border-top: 1px solid #373737;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 1);
      @include transition(all 400ms);
    }
  }

  ////////////////////////////////////////////////////////////
  // this second part of the code will be adjusted when we  //
  // want to have more than three items in our accordion    //
  ////////////////////////////////////////////////////////////

  // some fixed values; they can be adjusted to change the
  // appearance of the accordion
  $slides:                  3;
  $accordion_aspect_ratio:  2/1;
  $slide_aspect_ratio:      16/10;

  // these values are required multiple times, therefore I
  // store them in some variables here
  $slide_h: 100% / $accordion_aspect_ratio;
  $slide_w: $slide_h * $slide_aspect_ratio;

  // this sets the height of the accordion
  padding-bottom: $slide_h;

  ul li {
    // the actual width of the slides; the size they will
    // cover when they are expanded
    width: $slide_w;

    // the negative right margin makes the slides overlap
    margin-right: 100% / $slides - $slide_w;

    // this sets the height of each slide
    padding-bottom: $slide_h;
  }

  // when the mouse is over the accordion, shrink all slides
  // to do this, we have to increase the negative right
  // margin so that the slides overlap more
  ul:hover li {
    margin-right: (100% - $slide_w) / ($slides - 1) - $slide_w;
  }

  // except for the hovered slide, this one is expanded
  // a margin-right of zero means that the next slide will
  // not overlap this one at all
  ul:hover li:hover {
    margin-right: 0;
  }
}
{% endhighlight %}

As you can see, the behavior is configured with three variables. `$slides` adjusts the number of supported entries, `$accordion_aspect_ratio` sets the aspect ratio of the accordion (when the size of the website changes, so will the accordion) and `$slide_aspect_ratio`. The latter describes the aspect ratio of the expanded slide and should not be set to a greater value than the `$accordion_aspect_ratio`.

## Variable number of slides

Our next goal is to support any number of items. This can be achieved by replacing the bottom half of the style code above with a for-loop.

<div class="accordion accordion-items-8">
  <ul>
    <li style="background:#AC367D"></li>
    <li style="background:#DA7844"></li>
    <li style="background:#2D9072"></li>
    <li style="background:#A1CC40"></li>
    <li style="background:#DA85B9"></li>
    <li style="background:#FFBE9C"></li>
    <li style="background:#78C4AD"></li>
    <li style="background:#D7F495"></li>
  </ul>
</div>

{% highlight html %}
<div class="accordion accordion-items-8">
  <ul>
    <li style="background:#AC367D"></li>
    <li style="background:#DA7844"></li>
    <li style="background:#2D9072"></li>
    <li style="background:#A1CC40"></li>
    <li style="background:#DA85B9"></li>
    <li style="background:#FFBE9C"></li>
    <li style="background:#78C4AD"></li>
    <li style="background:#D7F495"></li>
  </ul>
</div>
{% endhighlight %}

{% highlight scss %}
// replace the "second part" of the .accordion
// class above with the following code
@for $slides from 3 through 10 {

  &.accordion-items-#{$slides} {

    // decrease height for increasing number of items
    $accordion_aspect_ratio: 1.3 + $slides / 5;
    $slide_aspect_ratio: 16/10;

    $slide_h: 100% / $accordion_aspect_ratio;
    $slide_w: $slide_h * $slide_aspect_ratio;

    padding-bottom: $slide_h;

    ul li {
      width: $slide_w;
      margin-right: 100% / $slides - $slide_w;
      padding-bottom: $slide_h;
    }

    ul:hover li {
      margin-right: (100%-$slide_w) / ($slides - 1) - $slide_w;
    }

    ul:hover li:hover {
      margin-right: 0;
    }
  }
}
{% endhighlight %}


## Background images

As a next step, we want to add pictures to our accordion. To achieve this, we set a background image for each slide and add a little bit of styling to the `<li>` element of our accordion.

<div class="accordion accordion-items-4">
  <ul>
  <li style="background-image:url('https://lorempixel.com/560/420/nature/1')"></li>
  <li style="background-image:url('https://lorempixel.com/560/420/nature/2')"></li>
  <li style="background-image:url('https://lorempixel.com/560/420/nature/3')"></li>
  <li style="background-image:url('https://lorempixel.com/560/420/nature/4')"></li>
  </ul>
</div>

{% highlight html %}
<div class="accordion accordion-items-4">
  <ul>
  <li style="background-image:url('https://lorempixel.com/560/420/nature/1')"></li>
  <li style="background-image:url('https://lorempixel.com/560/420/nature/2')"></li>
  <li style="background-image:url('https://lorempixel.com/560/420/nature/3')"></li>
  <li style="background-image:url('https://lorempixel.com/560/420/nature/4')"></li>
  </ul>
</div>
{% endhighlight %}

{% highlight scss %}
// add this to the appropriate
// place in the accordion class
.accordion {
  ul li {
    background-repeat: no-repeat;
    background-position: center center;
    background-size: cover;
  }
}
{% endhighlight %}


## Captions

Finally we want to have some captions on our slides. Since they should look really awesome we will add some transitions!

<div class="accordion accordion-items-4">
  <ul>
    <li style="background-image:url('https://lorempixel.com/560/420/nature/5')">
      <div>
        <h3>Lorem Ipsum</h3>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit.<br><a href="#">read on »</a></p>
      </div>
    </li>
    <li style="background-image:url('https://lorempixel.com/560/420/nature/6')">
      <div>
        <h3>Lorem Ipsum</h3>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit.<br><a href="#">read on »</a></p>
      </div>
    </li>
    <li style="background-image:url('https://lorempixel.com/560/420/nature/7')">
      <div>
        <h3>Lorem Ipsum</h3>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit.<br><a href="#">read on »</a></p>
      </div>
    </li>
    <li style="background-image:url('https://lorempixel.com/560/420/nature/8')">
      <div>
        <h3>Lorem Ipsum</h3>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit.<br><a href="#">read on »</a></p>
      </div>
    </li>
  </ul>
</div>

{% highlight html %}
<div class="accordion accordion-items-4">
  <ul>
    <li style="background-image:url('https://lorempixel.com/560/420/nature/5')">
      <div>
        <h3>Lorem Ipsum</h3>
        <p>Lorem ipsum...
           <br><a href="#">read on »</a>
        </p>
      </div>
    </li>
    <li style="background-image:url('https://lorempixel.com/560/420/nature/6')">
      <div>
        <h3>Lorem Ipsum</h3>
        <p>Lorem ipsum...
           <br><a href="#">read on »</a>
        </p>
      </div>
    </li>
    <li style="background-image:url('https://lorempixel.com/560/420/nature/7')">
      <div>
        <h3>Lorem Ipsum</h3>
        <p>Lorem ipsum...
           <br><a href="#">read on »</a>
        </p>
      </div>
    </li>
    <li style="background-image:url('https://lorempixel.com/560/420/nature/8')">
      <div>
        <h3>Lorem Ipsum</h3>
        <p>Lorem ipsum ...
           <br><a href="#">read on »</a>
        </p>
      </div>
    </li>
  </ul>
</div>
{% endhighlight %}

{% highlight scss %}
// add this to the appropriate
// place in the accordion class
.accordion {
  ul li {
    font-size: 14px;

    div {
      position: absolute;
      bottom: 0;
      width: 100%;
      padding: 20px;

      overflow: hidden;
      opacity: 0;

      @include transition(all 300ms);
      @include background-image(linear-gradient(top, rgba(0,0,0,0) 0%,rgba(0,0,0,1) 100%));

      h3 {
        @include transition(all 500ms);
        @include translateX(-30px);
      }

      a {
        display: inline-block;
        @include transition(all 500ms);
        @include translateX(-30px);
      }

      p {
        display: inline-block;
        @include transition(all 500ms);
        @include translateX(-60px);
      }
    }

    &:hover div {
      opacity: 1;

      h3, a, p {
        @include translateX(0px);
      }
    }
  }
}
{% endhighlight %}

## Final words

That's it! I hope you can use this technique somewhere. If you have further questions just use the comment form below! And it would be awesome if you could post a link if you used this accordion somewhere! Below you find the final SASS class.


{% highlight scss %}
.accordion {

  ////////////////////////////////////////////////////////////
  // the first part of the style code is independent from   //
  // the number of slides in the accordion                  //
  ////////////////////////////////////////////////////////////

  // the accordion shall always have a fixed aspect ration in
  // order to prevent distortion. Therefore we set the height
  // to zero and define a bottom padding in percent. This is
  // done down in the second half.
  height: 0;

  position: relative;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 1);

  ul {
    margin: 0;
    padding: 0;

    // remove white space between slides
    font-size: 0;

    li {
      height: 0;
      margin: 0;
      padding: 0;
      display: inline-block;
      position: relative;
      border-top: 1px solid #373737;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 1);
      @include transition(all 400ms);

      // these three lines are only required if you
      // are using background images
      background-repeat: no-repeat;
      background-position: center center;
      background-size: cover;

      // from here to the and of li is only necessary
      // if you want to have captions
      font-size: 14px;

      div {
        position: absolute;
        bottom: 0;
        width: 100%;
        padding: 20px;

        overflow: hidden;
        opacity: 0;

        @include transition(all 300ms);
        @include background-image(linear-gradient(top, rgba(0,0,0,0) 0%,rgba(0,0,0,1) 100%));

        h3 {
          @include transition(all 500ms);
          @include translateX(-30px);
        }

        a {
          display: inline-block;
          @include transition(all 500ms);
          @include translateX(-30px);
        }

        p {
          display: inline-block;
          @include transition(all 500ms);
          @include translateX(-60px);
        }
      }

      &:hover div {
        opacity: 1;

        h3, a, p {
          @include translateX(0px);
        }
      }
    }
  }

  ////////////////////////////////////////////////////////////
  // this second part of the code provides sub classes for  //
  // different item counts                                  //
  ////////////////////////////////////////////////////////////

  @for $slides from 3 through 10 {

    &.accordion-items-#{$slides} {

      // decrease height for increasing number of items
      $accordion_aspect_ratio: 1.3 + $slides / 5;
      $slide_aspect_ratio: 16/10;

      $slide_h: 100% / $accordion_aspect_ratio;
      $slide_w: $slide_h * $slide_aspect_ratio;

      padding-bottom: $slide_h;

      ul li {
        width: $slide_w;
        margin-right: 100% / $slides - $slide_w;
        padding-bottom: $slide_h;
      }

      ul:hover li {
        margin-right: (100%-$slide_w) / ($slides - 1) - $slide_w;
      }

      ul:hover li:hover {
        margin-right: 0;
      }
    }
  }
}
{% endhighlight %}
