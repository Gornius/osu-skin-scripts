#!/bin/bash
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU
# General Public License
# along with this program.  If not, see
# <https://www.gnu.org/licenses/>.


# ================= IMPORTANT NOTE ================= 
# To run this script in Windows you need to install `git bash` and `image
# magick`. Default options for both of them should enable you to just
# double-click this script and generate everything correctly.

# ======= DOCUMENTATION IS PROVIDED AT BOTTOM OF THE SCRIPT ========


# ---- OPTIONS ----
# DEPENDENCIES
runConvert="magick.exe convert"
runMogrify="magick.exe mogrify"

# Circle fonts options
circleGenerate=true
circleSize=150
circleHeight=150
circleWidth=0
circleFontFace="Wingdings"
circleFontColor=white
circleOutlineColor=orange
circleOutlineWidth=3
circleMarginTop=0
circleMarginBot=0

# Score fonts options
scoreGenerate=true
scoreSize=65
scoreHeight=62
scoreWidth=0
scoreFontFace="Wingdings-2"
scoreFontColor=lime
scoreOutlineColor=#777777
scoreOutlineWidth=1
scoreMarginTop=35
scoreMarginBot=15
scoreXText="x"

# Combo fonts options
comboGenerate=true
comboSize=100
comboHeight=100
comboWidth=0
comboFontFace="Wingdings-3"
comboFontColor=white
comboOutlineColor=pink
comboOutlineWidth=4
comboMarginTop=0
comboMarginBot=-10
comboXText="x"

# ---- CODE ----
# PROPER CODE SECTION DON'T TOUCH ANYTHING IF YOU HAVE NO IDEA ABOUT BASH!
# Although if you know BASH scripting, you can do some cool things with this,
# such as random colors.
circleParams="
-density 300 \
-resample 100 \
-background none \
-size x$(expr $circleSize \* 3) \
-font $circleFontFace \
-fill $circleFontColor \
-gravity center \
-strokewidth $(expr $circleOutlineWidth \* 3) \
-stroke $circleOutlineColor \
-extent $(echo $circleWidth)x$(expr $circleHeight + $circleMarginTop + $circleMarginBot)-0+$(expr $circleMarginBot / 2 - $circleMarginTop / 2)
"
scoreParams="
-density 300 \
-resample 100 \
-background none \
-size x$(expr $scoreSize \* 3) \
-font $scoreFontFace \
-fill $scoreFontColor \
-gravity center \
-strokewidth $(expr $scoreOutlineWidth \* 3) \
-stroke $scoreOutlineColor \
-extent $(echo $scoreWidth)x$(expr $scoreHeight + $scoreMarginTop + $scoreMarginBot)-0+$(expr $scoreMarginBot / 2 - $scoreMarginTop / 2)
"

comboParams="
-density 300 \
-resample 100 \
-background none \
-size x$(expr $comboSize \* 3) \
-font $comboFontFace \
-fill $comboFontColor \
-gravity center \
-strokewidth $(expr $comboOutlineWidth \* 3) \
-stroke $comboOutlineColor \
-extent $(echo $comboWidth)x$(expr $comboHeight + $comboMarginTop + $comboMarginBot)-0+$(expr $comboMarginBot / 2 - $comboMarginTop / 2)
"

# Make temp folder
mkdir fontgen-temp;

# Generate default
if $circleGenerate; then
    echo "Generating circle fonts...";
    for i in {0..9}; do
        $runConvert $circleParams label:"$i" "fontgen-temp/default-$i@2x.png";
    done;
    echo "Done!";
fi

# Generate score
if $scoreGenerate; then
    echo "Generating score fonts...";
    for i in {0..9} "," "." "%"; do
        $runConvert $scoreParams label:"$i" "fontgen-temp/score-$i@2x.png";
    done;
    $runConvert $scoreParams label:"$scoreXText" "fontgen-temp/score-x@2x.png";
    cd fontgen-temp;
    mv "score-,@2x.png" "score-comma@2x.png";
    mv "score-.@2x.png" "score-dot@2x.png";
    mv "score-%@2x.png" "score-percent@2x.png";
    cd ..;
    echo "Done!";
fi

# Generate combo
if $comboGenerate; then
    echo "Generating combo fonts...";
    for i in {0..9} "," "." "%"; do
        $runConvert $comboParams label:"$i" "fontgen-temp/combo-$i@2x.png";
    done;
    $runConvert $comboParams label:"$comboXText" "fontgen-temp/combo-x@2x.png";
    cd fontgen-temp;
    mv "combo-,@2x.png" "combo-comma@2x.png";
    mv "combo-.@2x.png" "combo-dot@2x.png";
    mv "combo-%@2x.png" "combo-percent@2x.png";
    cd ..;
    echo "Done!";
fi

# Make temp folder to make SD elements and resize them
echo "Resizing HD elements to SD elements..."
mkdir fontgen-temp/resize-temp;
cd fontgen-temp/resize-temp;
cp ../*.png .;
for i in *; do
    $runMogrify -resize 50% $i;
    echo $i | sed 's/\.*\@2x\.png/\.png/' | xargs -I{} mv $i {};
done;
mv *.png ..;
cd ..;
mv *.png ..;
cd ..;

# Remove temp folder
rm -rf fontgen-temp;
echo "Done!";


## GENERAL OPTIONS

## Path to run convert program (from imagemagick package, if you don't know
## what's this, don't change anything here, if you're more advanced user. Using
## it under WSL or bare Linux might speed things up, but you will need to
## install imagemagick on your Linux subsystem, then change the "runConvert"
## value to "convert".
#runConvert="magick.exe convert"

## Same, but for mogrify, also packaged with imagemagick, needed to make SD
## versions of a image
#runMogrify="magick.exe mogrify"

## IMPORTANT: ALL OF SIZES ARE MEANT FOR @2x FILE DIMENSIONS! THEY ARE THEN
## AUTOMATICALLY CONVERTED TO SD RESOLUTION!!!

## Do you want to generate these skins elements? (true/false)
#circleGenerate=true

## Size of a image (THIS NEED TO BE SET!) Height of a image (might be not
## precise due to DPI calculations
#circleSize=150

## Height of a circle to better fit image resolution (usually this value
## will be (~20-30% of original size). This value + MarginTop + MarginBot is
##equal to overall image height.
#circleHeight=104

## Width is a final image width. You might want to use this option to
## descrease/increase spacing between letters. Default is 0, which means auto.
## If you want to have a monospace-like font, you need to set this.
#circleWidth=0

## Font face (Either returned by `magick convert -list font` or relative path to
## the font (example font-file is caviar-dreams fonts in osu-fontgen-fonts
## directory)). REMEMBER IT'S CASE SENSITIVE!
#circleFontFace="./osu-fontgen-fonts/CaviarDreams.ttf"

## Font color (either its name, or hex value, ex. #ffffff for white)
#circleFontColor=white

## Outline color (either its name, or hex value, ex. #ffffff for white)
#circleOutlineColor=#777777

## Width of an outline (in pixels)
#circleOutlineWidth=3

## Bottom and Top margins are here to help you space fonts inside skin
## elements. They contribute to total image height. MarginBot is also sometimes
## needed to make sure comma symbol doesn't get cut in half.
#circleMarginTop=0
#circleMarginBot=10

## scoreXText is score and combo specifig, and it's label for what will be
## displayed as an "x" near combo. If you leave it blank, it won't generate new 
## character for that symbol.
#scoreXText="x"
