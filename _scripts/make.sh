#!/bin/bash

# ./_color_extractor/make.sh
# ./_color_extractor/color_extractor assets/pictures _sass/_colors.scss

compass compile _sass

find assets/pictures \( -name large -prune \) -o \( -name medium -prune \) -o \( -name small -prune \) -o -type f -exec ./_scripts/make_thumbs.sh {} \;
