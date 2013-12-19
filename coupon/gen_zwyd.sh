#!/bin/bash
if [ $# -ne 6 ]
then
   echo "$0 url x, y, r, tmp_png output_filename"
   echo "参数错误:请按[图片url，剪裁中心x, 剪裁中心y, 剪裁半径r, 输出文件名 ]顺序传参"
   exit 1
fi
#convert  -size 300x300 xc:none -draw 'circle 150,150 150,1'  circle.gif
convert -resize 640x640 $1 $5
ruby ./crop2.rb $5 $2 $3 $4
mogrify -resize 320x320 $5
mogrify  -matte -draw 'image Dst_In 10,10 0,0 "circle.gif"'  $5
convert -quality 85 -draw "image Over 573,231 0,0 \"$5\"" zwyd.jpg $6
rm $5
convert -resize 275x275 $6 $5
jpegoptim $5
jpegoptim $6
mv $5 ../public/t$6
mv $6 ../public/
