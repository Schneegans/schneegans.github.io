---
layout: post
title: "C++11 Properties!"
tagline: "how I code them."
category: tutorials
teaser: "properties.jpg"
colors: "color-properties"
description: "I think there is a tight connection. Image by <a href='https://www.flickr.com/photos/hulagway/6020190512/'>whologwhy</a>."
tags: ["tutorial", "c++", "code"]
---

Based on the signal class from the previous post we can implement a class which holds a value and notifies anyone who's interested in value changes.

<!--more-->

## What's the Observer Pattern?

<div class="well"><p class="quote"> [...] a software design pattern in which an object, called the subject, maintains a list of its dependants, called observers, and notifies them automatically of any state changes, usually by calling one of their methods.<a href="https://en.wikipedia.org/wiki/Observer_pattern"> - Wikipedia</a></p></div>

So basically it allows for automatic notification event propagation whenever a value changed. Since these state change notifications work really well with the  [Vala Properties](https://wiki.gnome.org/Projects/Vala/PropertiesSample) (and similarly with C# Properties), I'll present a method how to implement something similar in C++.

## The Basic Property Template Class

In its most basic form the Property template looks like the following. An instance of the template encapsulates a value which can be changed with the `set()` and `get()` methods. If the value is changed this way, the signal `on_change()` will be emitted.

{% highlight c++ %}
#ifndef PROPERTY_HPP
#define PROPERTY_HPP

#include "Signal.hpp"

// A Property encapsulates a value and may inform
// you on any changes applied to this value.

template <typename T>
class Property {

 public:
  typedef T value_type;

  Property(T const& val) : value_(val) {}

  // returns a Signal which is fired when the internal value
  // has been changed. The new value is passed as parameter.
  virtual Signal<T> const& on_change() const {
    return on_change_;
  }

  // sets the Property to a new value.
  // on_change() will be emitted.
  virtual void set(T const& value) {
    if (value != value_) {
      value_ = value;
      on_change_.emit(value_);
    }
  }

  // returns the internal value
  virtual T const& get() const { return value_; }

  // if there are any Properties connected to this Property,
  // they won't be notified of any further changes
  virtual void disconnect_auditors() {
    on_change_.disconnect_all();
  }

  // assigns the value of another Property
  virtual Property<T>& operator=(Property<T> const& rhs) {
    set(rhs.value_);
    return *this;
  }

  // assigns a new value to this Property
  virtual Property<T>& operator=(T const& rhs) {
    set(rhs);
    return *this;
  }

  // returns the value of this Property
  T const& operator()() const {
    return Property<T>::get();
  }

 private:
  Signal<T> on_change_;

  T value_;
};

#endif /* PROPERTY_HPP */
{% endhighlight %}


## Simple Usage Example

You can copy the above code and save it in a file named `Property.hpp`. Save this file in a directory together with the Signal template from the [previous post]({% post_url 2015-09-20-signal-slot %}). Save the ode below as `main.cpp` in the same directory.

{% highlight c++ %}
#include "Property.hpp"
#include <iostream>

int main() {
  Property<int> Integer(0);

  Integer.on_change().connect([](int val) {
    std::cout << "Value changed to: " << val << std::endl;
  });

  Integer = 42;

  return 0;
}

{% endhighlight %}

You can compile the example with:

{% highlight bash %}
g++ --std=c++0x main.cpp
{% endhighlight %}

And if you execute the resulting application you will get the following output:

{% highlight bash %}
Value changed to: 42
{% endhighlight %}

## Improving the Basic Template Class

There are several ways in which we can improve this template! First we will add a default constructor, then we will add stream operator support and then we will add the possibility to connect properties to another.

### Default Constructor

First of all, we can add a default constructor and some copy and move constructors. This is a little bit tricky, since the default constructor for built-in types does not initialize the value. This will cause problems because the value comparison in `set()` might fail if the value is not initialized. Therefore we need template specialisations for the default constructor! Let's look at the code. First, replace the current constructor with the following list of constructors:

{% highlight c++ %}
// Properties for built-in types are automatically
// initialized to 0. See template spezialisations
// at the bottom of this file
Property() {}

Property(T const& val)
  : value_(val) {}

Property(T&& val)
  : value_(std::move(val)) {}

Property(Property<T> const& to_copy)
  : value_(to_copy.value_) {}

Property(Property<T>&& to_copy)
  : value_(std::move(to_copy.value_)) {}
{% endhighlight %}

And put the following specialisations directly before the `#endif` preprocessor directive.

{% highlight c++ %}
// specialization for built-in default contructors
template<> inline Property<double>::Property()
  : value_(0.0) {}

template<> inline Property<float>::Property()
  : value_(0.f) {}

template<> inline Property<short>::Property()
  : value_(0) {}

template<> inline Property<int>::Property()
  : value_(0) {}

template<> inline Property<char>::Property()
  : value_(0) {}

template<> inline Property<unsigned>::Property()
  : value_(0) {}

template<> inline Property<bool>::Property()
  : value_(false) {}
{% endhighlight %}

Now you can skip the initialization of the `Integer` property in the example above because the constructor will take care of this.

### Stream operators

For convenience we will overload the stream operators for our template class. To do so, add the include `#include <iostream>` and put the following code directly before the `#endif` preprocessor directive.

{% highlight c++ %}
// stream operators
template<typename T>
std::ostream& operator<<(std::ostream& str, Property<T> const& val) {
  str << val.get();
  return str;
}

template<typename T>
std::istream& operator>>(std::istream& str, Property<T>& val) {
  T tmp;
  str >> tmp;
  val.set(tmp);
  return str;
}
{% endhighlight %}

Now we can do things like this:

{% highlight c++ %}
#include "Property.hpp"
#include <sstream>

int main() {
  Property<int> Integer;

  Integer.on_change().connect([](int val) {
    std::cout << "Value changed to: " << val << std::endl;
  });

  std::cout << "Value: " << Integer << std::endl;

  std::stringstream sstr("42");
  sstr >> Integer;

  return 0;
}
{% endhighlight %}

Which will produce:

{% highlight bash %}
Value: 0
Value changed to: 42
{% endhighlight %}


### Connect Properties amongst each other

This final change allows for data flow modelling. I won't post the code here for it's a little bit longer but you can [download the final version of the class here](/assets/files/code/Property.hpp). But I'll show you an example of what's possible with this class:

{% highlight c++ %}
#include "Property.hpp"
#include <sstream>

int main() {
  Property<float> InputValue;
  Property<float> OutputValue;
  Property<bool>  CriticalSituation;

  OutputValue.connect_from(InputValue);

  OutputValue.on_change().connect([&](float val) {
    std::cout << "Output: " << val << std::endl;
    if (val > 0.5f) CriticalSituation = true;
    else            CriticalSituation = false;
  });

  CriticalSituation.on_change().connect([](bool val) {
    if (val) std::cout << "Danger danger!" << std::endl;
  });

  InputValue = 0.2;
  InputValue = 0.4;
  InputValue = 0.6;

  return 0;
}
{% endhighlight %}

This will produce:

{% highlight bash %}
Output: 0.2
Output: 0.4
Output: 0.6
Danger danger!
{% endhighlight %}

## Summary

As you can imagine, it's possible to do a lot of things here. There are numerous applications of these patterns and I really like the readability of the code. If you put these properties as members into classes the communication design becomes much easier and the class interface will be more intuitive.

Thank you for reading this code stuffed post but maybe you learned something! And if there are questions left feel free to ask!
