#!/bin/bash
if [ $# -ne 4 ]
then
   echo "$0 title output_filename"
   exit 1
fi
convert -font 'msyh.ttf' -fill "#309797" -pointsize 24 -draw "text 250,55\"${1}\"" -draw "image Over 28,28 189,189 \"${4}\""   demo.png $3
desc=$2
leng=${#desc}
for((i=1;i<=(leng+14)/15;i++));do
 hi=$[70+i*30]
 convert -font 'msyh.ttf' -fill "#3097ff" -pointsize 20 -draw "text 250,$hi\"${desc:((i-1)*15):15}\"" $3 $3
done
convert -resize 290x112 $3 "${3}_2.jpg"

