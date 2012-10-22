#!/bin/bash
if [ $# -ne 2 ]
then
   echo "$0 title output_filename"
   exit 1
fi
convert -font 'msyh.ttf' -fill "#309797" -pointsize 24 -draw "text 220,50\"${1}\"" demo.jpg $2
convert -resize 290x112 $2 "${2}_2.jpg"

