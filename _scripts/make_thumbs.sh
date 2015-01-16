#!/bin/bash

## Licence: DWTFYW
## This program is free software. It comes without any warranty, to
## the extent permitted by applicable law. You can redistribute it
## and/or modify it under the terms of the Do What The F**k You Want
## To Public License, Version 2, as published by Sam Hocevar. See
## http://sam.zoy.org/wtfpl/COPYING for more details. *

## Author: Donn Ingle, Oct 2010, South Africa

## Notes:
## This script runs once per image file passed to it: i.e. you loop it from somewhere else.
## A extra 'thumbs' directory is made in the directory it is run from, you may want to rm -fr it.

## Example using find:
##   find . \( -name NOTINTHERE -prune \) -o \( -name thumbs -prune \) -o -iname "*.png" -exec makethumbs {} \;
##   That will 1) Skip the NOTINTHERE directory, 2) Skip the thumbs directories (This is vital, else you get recursions)
##   3) Look for all png files and then run this script on each.
## Example 2:
##   find . \( -name wiki -prune \) -o \( -name thumbs -prune \) -o \( -iname "p_*" -prune \) -o \( -iname "*dev*" -prune \) -o -iname "*.*" -type f -exec makethumbs {} \;
##   1) Skip 'wiki' directory, 2) skip 'thumbs', 3) skip anything starting with p_ (or whatever you like) 4) skip anything with 'dev' in it
##   5) Looks for any kinds of files 6) makes sure they are files not directories 7) runs this script on each.


E_BADARGS=65

if [ ! -n "$1" ]
then
  echo "Usage: `basename $0` some_image_to_process"
  echo "Will make a thumb/ dir and a thumbnail of a given png in it."
  echo "Run from a top of a tree of images to thumbnail all image files below it."
  echo "Tip: use find's exec to run this script."
  exit $E_BADARGS
fi

paf="$1"

## Get out if this is not an image file
if ! identify "$paf" &>/dev/null; then exit 1; fi

filename=`basename "$1"`

cwd=`dirname "$paf"`


# small

## Make small if it's not there. Also touch the file to make date same so that we trigger thumb creation later on.
if [ ! -e "$cwd/small" ]; then
   mkdir "$cwd/small"
   touch "$paf"
fi

## make a string of the new thumbnail path and name
new_thumb_file="$cwd/small/$filename"

## Test new thumb file against current image. If it's older, then we remake it>
## (This also covers the case where the thumbnail does not exist at all.)
if [[ "$paf" -nt "$new_thumb_file" ]]; then
   convert -geometry 370x "$paf" "$new_thumb_file"
   if [ $? -ne 0 ]; then
      echo ERROR making $new_thumb_file
   else
      echo Made new small thumb:  $paf TO $new_thumb_file
   fi
fi

# medium

## Make medium if it's not there. Also touch the file to make date same so that we trigger thumb creation later on.
if [ ! -e "$cwd/medium" ]; then
   mkdir "$cwd/medium"
   touch "$paf"
fi

## make a string of the new thumbnail path and name
new_thumb_file="$cwd/medium/$filename"

## Test new thumb file against current image. If it's older, then we remake it>
## (This also covers the case where the thumbnail does not exist at all.)
if [[ "$paf" -nt "$new_thumb_file" ]]; then
   convert -geometry 570x "$paf" "$new_thumb_file"
   if [ $? -ne 0 ]; then
      echo ERROR making $new_thumb_file
   else
      echo Made new medium thumb:  $paf TO $new_thumb_file
   fi
fi

# large

## Make medium if it's not there. Also touch the file to make date same so that we trigger thumb creation later on.
if [ ! -e "$cwd/large" ]; then
   mkdir "$cwd/large"
   touch "$paf"
fi

## make a string of the new thumbnail path and name
new_thumb_file="$cwd/large/$filename"

## Test new thumb file against current image. If it's older, then we remake it>
## (This also covers the case where the thumbnail does not exist at all.)
if [[ "$paf" -nt "$new_thumb_file" ]]; then
   convert -geometry 770x "$paf" "$new_thumb_file"
   if [ $? -ne 0 ]; then
      echo ERROR making $new_thumb_file
   else
      echo Made new large thumb:  $paf TO $new_thumb_file
   fi
fi
