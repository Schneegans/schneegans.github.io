---
layout: post
title: "C++11 Signals and Slots!"
tagline: "how I code them."
category: tutorials
teaser: "signals.jpg"
colors: "color-signals"
description: "A slot canyon. Image by <a href='https://www.flickr.com/photos/photophilde/5000685616/'>photophilde</a>."
tags: ["featured", "tutorial", "c++", "code"]
---

I've been asked multiple times how I would implement a signal / slot mechanism in modern C++. Here is the answer!

<!--more-->

## What's the Signal / Slot Pattern?

<div class="well"><p class="quote"> [...] a language construct [...] which makes it easy to implement the Observer pattern while avoiding boilerplate code. The concept is that GUI widgets can send signals containing event information which can be received by other controls using special functions known as slots.<a href="https://en.wikipedia.org/wiki/Signals_and_slots"> - Wikipedia</a></p></div>

So basically it allows for event based inter-object communication. In my opinion it's intuitive to use and produces easily readable code when used in a moderate amount. And the big plus: It can be added to your program with one simple template class!

There are many libraries around (refer to the linked Wikipedia article) implementing this pattern, but it's so easy to implement on you own that I would recommend to do this without an additional dependency. All you need is the header I posted below. And it's a good exercise.

## The Signal Template Class

Below you can find the entire class. Because this class is using variadic templates you can define signals which pass any kind of data to their slots. Basically you can create signals which allow for arbitrary slot signatures. The emit method will accept the same argument types you declared as template parameters for the Signal class. The class is documented with comments and should be quite understandable. Further below you will find two usage examples.

{% highlight c++ %}
#ifndef SIGNAL_HPP
#define SIGNAL_HPP

#include <functional>
#include <map>

// A signal object may call multiple slots with the
// same signature. You can connect functions to the signal
// which will be called when the emit() method on the
// signal object is invoked. Any argument passed to emit()
// will be passed to the given functions.

template <typename... Args>
class Signal {

 public:

  Signal() : current_id_(0) {}

  // copy creates new signal
  Signal(Signal const& other) : current_id_(0) {}

  // connects a member function of a given object to this Signal
  template <typename F, typename... A>
  int connect_member(F&& f, A&& ... a) const {
    slots_.insert({++current_id_, std::bind(f, a...)});
    return current_id_;
  }

  // connects a std::function to the signal. The returned
  // value can be used to disconnect the function again
  int connect(std::function<void(Args...)> const& slot) const {
    slots_.insert(std::make_pair(++current_id_, slot));
    return current_id_;
  }

  // disconnects a previously connected function
  void disconnect(int id) const {
    slots_.erase(id);
  }

  // disconnects all previously connected functions
  void disconnect_all() const {
    slots_.clear();
  }

  // calls all connected functions
  void emit(Args... p) {
    for(auto it : slots_) {
      it.second(p...);
    }
  }

  // assignment creates new Signal
  Signal& operator=(Signal const& other) {
    disconnect_all();
  }

 private:
  mutable std::map<int, std::function<void(Args...)>> slots_;
  mutable int current_id_;
};

#endif /* SIGNAL_HPP */
{% endhighlight %}

## Simple Usage

The example below creates a simple signal. To this signal functions may be connected which accept a string and an integer. A lambda is connected and gets called when the emit method of the signal is called.

{% highlight c++ %}
#include "Signal.hpp"
#include <iostream>

int main() {

  // create new signal
  Signal<std::string, int> signal;

  // attach a slot
  signal.connect([](std::string arg1, int arg2) {
      std::cout << arg1 << " " << arg2 << std::endl;
  });

  signal.emit("The answer:", 42);

  return 0;
}

{% endhighlight %}

When you saved the Signal class as `Signal.hpp` and the above example as `main.cpp` you can compile the example with:

{% highlight bash %}
g++ --std=c++0x main.cpp
{% endhighlight %}

And if you execute the resulting application you will get the following output:

{% highlight bash %}
The answer: 42
{% endhighlight %}


## Advanced Usage

This example shows the usage with classes. A message gets displayed when the button is clicked. Note that neither the button knows anything of a message nor does the message know anything about a button. That's awesome! You can compile this example in the same way as the first.

{% highlight c++ %}
#include "Signal.hpp"
#include <iostream>

class Button {
 public:
  Signal<> on_click;
};

class Message {
 public:
  void display() const {
    std::cout << "Hello World!" << std::endl;
  }
};

int main() {
  Button  button;
  Message message;

  button.on_click.connect_member(&Message::display, message);
  button.on_click.emit();

  return 0;
}

{% endhighlight %}


## Issues & Next Steps

There are two drawbacks in this simple implementation: It's not threadsafe and you cannot disconnect a slot from a signal from within the slot callback. Both problems are easy to solve but would make this example more complex.

Using this Signal class other patterns can be implemented easily. In a follow-up post I'll present another simple class: the Property. This will allow for a clean implementation of the [observer pattern](https://en.wikipedia.org/wiki/Observer_pattern).

Have some fun coding events in C++!
