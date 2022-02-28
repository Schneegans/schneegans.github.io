---
layout: post
title: "C++17 Command Line Parsing!"
category: tutorials
teaser: "commandline.jpg"
colors: "color-commandline"
license: "public domain"
tagline: "The final --help output of the example application below"
tags: ["tutorial", "c++", "code"]
---

Parsing command line options is part of many applications. While there are many good libraries out there, writing your own can be a very good C++ exercise.

<!--more-->

## Yet another command line parser?

For a bigger project which requires complex conditional command line parsing I would definitely suggest using an existing library. Most likely, the best choice would be [boost::program_options](https://www.boost.org/doc/libs/1_70_0/doc/html/program_options.html). However, this introduces a huge dependency for a task which should be easy to solve. Therefore, especially for small-scale prototype applications, a simple class which you can copy to your source tree might be a better solution.

## The command line class

I have been using this class in various projects now and it always did a great job. It supports arguments as `int32_t`, `uint32_t`, `double`, `float`, `bool` and `std::string`. For arguments with type `bool`, no value has to be given - that way simple flags like `--help` can be implemented.

It's quite easy to extend it to support custom data types. It uses [std::variant](https://en.cppreference.com/w/cpp/utility/variant) to store pointers to local variables which are then set to the values given by the user. The actual parsing is done using [std::stringstream](https://en.cppreference.com/w/cpp/io/basic_stringstream).

##### CommandLine.hpp
{% highlight c++ linenos %}
#ifndef COMMAND_LINE_HPP
#define COMMAND_LINE_HPP

#include <iostream>
#include <string>
#include <variant>
#include <vector>

// This class is a simple and effective class to parse command line arguments.
// For each possible argument it stores a pointer to a variable. When the
// corresponding argument is set on the command line (given to the parse()
// method) the variable is set to the given value. If the option is not set,
// the variable is not touched. Hence it should be initialized to a default
// state. 
// For each argument, several names (aliases) can be defined. Thus, the same
// boolean could be set via '--help' or '-h'. While not required, it is a good
// practice to precede the argument names with either '--' or '-'. Except for
// booleans, a value is expected to be given. Booleans are set to 'true' if no
// value is provided (that means they can be used as simple flags as in the
// '--help' case). Values can be given in two ways: Either the option name and
// the value should be separated by a space or by a '='. Here are some valid
// examples:
// --string="Foo Bar"
// --string "Foo Bar"
// --help
// --help=false
// --help true

class CommandLine {
 public:

  // These are the possible variables the options may point to. Bool and
  // std::string are handled in a special way, all other values are parsed
  // with a std::stringstream. This std::variant can be easily extended if
  // the stream operator>> is overloaded. If not, you have to add a special
  // case to the parse() method.
  typedef std::variant<int32_t*, 
                       uint32_t*,
                       double*, 
                       float*, 
                       bool*, 
                       std::string*> Value;

  // The description is printed as part of the help message.
  explicit CommandLine(std::string description);

  // Adds a possible option. A typical call would be like this:
  // bool printHelp = false;
  // cmd.addArgument({"--help", "-h"}, &printHelp, "Print this help message");
  // Then, after parse() has been called, printHelp will be true if the user
  // provided the flag.
  void addArgument(std::vector<std::string> const& flags, 
                   Value const& value, std::string const& help);

  // Prints the description given to the constructor and the help
  // for each option.
  void printHelp(std::ostream& os = std::cout) const;

  // The command line arguments are traversed from start to end. That means,
  // if an option is set multiple times, the last will be the one which is
  // finally used. This call will throw a std::runtime_error if a value is
  // missing for a given option. Unknown flags will cause a warning on
  // std::cerr.
  void parse(int argc, char* argv[]) const;

 private:
  struct Argument {
    std::vector<std::string> mFlags;
    Value                    mValue;
    std::string              mHelp;
  };

  std::string           mDescription;
  std::vector<Argument> mArguments;
};

#endif // COMMAND_LINE_HPP
{% endhighlight %}

##### CommandLine.cpp
{% highlight c++ linenos %}
#include "CommandLine.hpp"

#include <algorithm>
#include <iomanip>

CommandLine::CommandLine(std::string description)
    : mDescription(std::move(description)) {
}

void CommandLine::addArgument(std::vector<std::string> const& flags,
                              Value const& value, std::string const& help) {
  mArguments.emplace_back(Argument{flags, value, help});
}

void CommandLine::printHelp(std::ostream& os) const {

  // Print the general description.
  os << mDescription << std::endl;

  // Find the argument with the longest combined flag length (in order
  // to align the help messages).
  
  uint32_t maxFlagLength = 0;

  for (auto const& argument : mArguments) {
    uint32_t flagLength = 0;
    for (auto const& flag : argument.mFlags) {
      // Plus comma and space.
      flagLength += static_cast<uint32_t>(flag.size()) + 2;
    }

    maxFlagLength = std::max(maxFlagLength, flagLength);
  }

  // Now print each argument.
  for (auto const& argument : mArguments) {

    std::string flags;
    for (auto const& flag : argument.mFlags) {
      flags += flag + ", ";
    }

    // Remove last comma and space and add padding according to the
    // longest flags in order to align the help messages.
    std::stringstream sstr;
    sstr << std::left << std::setw(maxFlagLength) 
         << flags.substr(0, flags.size() - 2);

    // Print the help for each argument. This is a bit more involved
    // since we do line wrapping for long descriptions.
    size_t spacePos  = 0;
    size_t lineWidth = 0;
    while (spacePos != std::string::npos) {
      size_t nextspacePos = argument.mHelp.find_first_of(' ', spacePos + 1);
      sstr << argument.mHelp.substr(spacePos, nextspacePos - spacePos);
      lineWidth += nextspacePos - spacePos;
      spacePos = nextspacePos;

      if (lineWidth > 60) {
        os << sstr.str() << std::endl;
        sstr = std::stringstream();
        sstr << std::left << std::setw(maxFlagLength - 1) << " ";
        lineWidth = 0;
      }
    }
  }
}

void CommandLine::parse(int argc, char* argv[]) const {

  // Skip the first argument (name of the program).
  int i = 1;
  while (i < argc) {

    // First we have to identify wether the value is separated by a space
    // or a '='.
    std::string flag(argv[i]);
    std::string value;
    bool        valueIsSeparate = false;

    // If there is an '=' in the flag, the part after the '=' is actually
    // the value.
    size_t equalPos = flag.find('=');
    if (equalPos != std::string::npos) {
      value = flag.substr(equalPos + 1);
      flag  = flag.substr(0, equalPos);
    }
    // Else the following argument is the value.
    else if (i + 1 < argc) {
      value           = argv[i + 1];
      valueIsSeparate = true;
    }

    // Search for an argument with the provided flag.
    bool foundArgument = false;

    for (auto const& argument : mArguments) {
      if (std::find(argument.mFlags.begin(), argument.mFlags.end(), flag) 
          != std::end(argument.mFlags)) {

        foundArgument = true;

        // In the case of booleans, there must not be a value present.
        // So if the value is neither 'true' nor 'false' it is considered
        // to be the next argument.
        if (std::holds_alternative<bool*>(argument.mValue)) {
          if (!value.empty() && value != "true" && value != "false") {
            valueIsSeparate = false;
          }
          *std::get<bool*>(argument.mValue) = (value != "false");
        }
        // In all other cases there must be a value.
        else if (value.empty()) {
          throw std::runtime_error(
            "Failed to parse command line arguments: "
            "Missing value for argument \"" + flag + "\"!");
        }
        // For a std::string, we take the entire value.
        else if (std::holds_alternative<std::string*>(argument.mValue)) {
          *std::get<std::string*>(argument.mValue) = value;
        }
        // In all other cases we use a std::stringstream to
        // convert the value.
        else {
          std::visit(
              [&value](auto&& arg) {
                std::stringstream sstr(value);
                sstr >> *arg;
              },
              argument.mValue);
        }

        break;
      }
    }

    // Print a warning if there was an unknown argument.
    if (!foundArgument) {
      std::cerr << "Ignoring unknown command line argument \"" << flag
                << "\"." << std::endl;
    }

    // Advance to the next flag.
    ++i;

    // If the value was separated, we have to advance our index once more.
    if (foundArgument && valueIsSeparate) {
      ++i;
    }
  }
}
{% endhighlight %}

## Usage

You can copy the source code from above to two files called `CommandLine.hpp` and `CommandLine.cpp`. Then store the code below in `main.cpp`.

##### main.cpp
{% highlight c++ linenos %}
#include "CommandLine.hpp"
#include <iostream>

int main(int argc, char* argv[]) {

  // This variables can be set via the command line.
  std::string oString    = "Default Value";
  int32_t     oInteger   = -1;
  uint32_t    oUnsigned  = 0;
  double      oDouble    = 0.0;
  float       oFloat     = 0.f;
  bool        oBool      = false;
  bool        oPrintHelp = false;

  // First configure all possible command line options.
  CommandLine args("A demonstration of the simple command line parser.");
  args.addArgument({"-s", "--string"},   &oString,   "A string value");
  args.addArgument({"-i", "--integer"},  &oInteger,  "A integer value");
  args.addArgument({"-u", "--unsigned"}, &oUnsigned, "A unsigned value");
  args.addArgument({"-d", "--double"},   &oDouble,   "A float value");
  args.addArgument({"-f", "--float"},    &oFloat,    "A double value");
  args.addArgument({"-b", "--bool"},     &oBool,     "A bool value");
  args.addArgument({"-h", "--help"},     &oPrintHelp,
      "Print this help. This help message is actually so long "
      "that it requires a line break!");

  // Then do the actual parsing.
  try {
    args.parse(argc, argv);
  } catch (std::runtime_error const& e) {
    std::cout << e.what() << std::endl;
    return -1;
  }

  // When oPrintHelp was set to true, we print a help message and exit.
  if (oPrintHelp) {
    args.printHelp();
    return 0;
  }

  // Print the resulting values.
  std::cout << "mString: "   << oString   << std::endl;
  std::cout << "mInteger: "  << oInteger  << std::endl;
  std::cout << "mUnsigned: " << oUnsigned << std::endl;
  std::cout.precision(std::numeric_limits<double>::max_digits10);
  std::cout << "mDouble: "   << oDouble   << std::endl;
  std::cout.precision(std::numeric_limits<float>::max_digits10);
  std::cout << "mFloat: "    << oFloat    << std::endl;
  std::cout << "mBool: "     << oBool     << std::endl;

  return 0;
}
{% endhighlight %}

Then you can compile the example application with the following command. You can also compile the application on a recent MSVC shipped with Visual Studio 2017.

{% highlight bash %}
g++ --std=c++17 main.cpp CommandLine.cpp
{% endhighlight %}

Running the executable without any arguments will show the default values of all available command line arguments. `./a.out --help` (or `./a.out -h`) will show a list of supported options.


## Further Ideas

While the class is quite useful in the current state, it could be improved in several ways. Most obvious is the lack of *required arguments*. A basic implementation would be simple: Just add a `bool` to the `CommandLine::Argument` struct indicating wether it's a required argument and throw an error if such an argument is not given.

However, you may want to have *dependent arguments* - if one argument is given, another one becomes possible or even required. This would not be straight-forward to implement in a proper way.

Anyway, I hope this class may help you to improve you productivity! If you spot any bugs or have ideas for improving it, let me know in the comments below! 