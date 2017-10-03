#!/bin/bash

./_color_extractor/make.sh
./_color_extractor/color_extractor assets/teasers _sass/_colors.scss

compass compile _sass

find assets/teasers \( -name thumbs -prune \) -o \( -name blurred -prune \) -o -type f -exec ./_scripts/make_thumbs.sh {} \;
