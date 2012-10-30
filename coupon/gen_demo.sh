#!/bin/bash
if [ $# -ne 5 ]
then
   echo "$0 title output_filename"
   exit 1
fi
convert -font 'msyh.ttf' -fill "#309797" -pointsize 24 -kerning 1.5 -draw "text 245,55\"${1}\"" -fill "gray" -pointsize 20 -kerning 1 -draw "text 245,100\"${2}\"" -draw "image Over 28,28 189,189 \"${4}\""   demo.png $3
convert -font 'msyh.ttf' -fill "red" -pointsize 15 -kerning 2 -draw "text 410,280\"${5}\""  $3 $3
convert -resize 290x112 $3 "${3}_2.jpg"

