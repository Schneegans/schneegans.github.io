#!/bin/bash

# get directory of script and cd to it
DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

valac --pkg gio-2.0 --pkg gdk-x11-3.0 --pkg cairo --Xcc=-lm main.vala image.vala color.vala -o color_extractor
