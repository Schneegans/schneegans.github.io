#!/bin/bash

compass compile _sass

find assets/pictures \( -name large -prune \) -o \( -name medium -prune \) -o \( -name small -prune \) -o -type f -exec ./_scripts/make_thumbs.sh {} \;
