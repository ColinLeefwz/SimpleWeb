#!/bin/bash
if [ $# -ne 6 ]
then
   echo "$0 url x, y, r, tmp_png output_filename"
   echo "参数错误:请按[图片url，剪裁中心x, 剪裁中心y, 剪裁半径r, 输出文件名 ]顺序传参"
   exit 1
fi
#convert  -size 300x300 xc:none -draw 'circle 150,150 150,1'  circle.gif
convert -auto-orient -resize 640x640 $1 $5
cp $5 copy_$2_$3_$4_$5
ruby ./crop2.rb $5 $2 $3 $4
mogrify -resize 310x310 $5
mogrify  -matte -draw 'image Dst_In 9,9 0,0 "circle.gif"'  $5
convert -quality 90 -draw "image Over 573,231 0,0 \"$5\"" zwyd.jpg $6
rm $5
convert -resize 275x275 $6 t$6
jpegoptim --strip-all  t$6
jpegoptim --strip-all  $6
mv t$6 ../public/t$6
mv $6 ../public/
