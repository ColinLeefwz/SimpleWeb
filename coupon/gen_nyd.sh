#!/bin/bash
if [ $# -ne 3 ]
then
   echo "$0 url tmp_png output_filename"
   echo "参数错误:请按[图片url，tmp, 输出文件名 ]顺序传参"
   exit 1
fi
#convert -size 268x360 xc:none bg.png
ruby ./crop3.rb $1 255 345 $2
convert -quality 90 -draw "image Over 1,1 0,0 \"$2\"" new_year_bg.png $3
jpegoptim --strip-all  $3
mv $3 ../public/
