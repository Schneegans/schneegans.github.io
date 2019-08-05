#!/bin/bash

./_color_extractor/make.sh
./_color_extractor/color_extractor assets/pictures/teasers _sass/_colors.scss

find assets/pictures/teasers \( -name thumbs -prune \) -o \( -name blurred -prune \) -o -type f -exec ./_scripts/make_thumbs.sh {} \;
