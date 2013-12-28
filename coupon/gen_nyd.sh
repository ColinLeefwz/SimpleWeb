#!/bin/bash
if [ $# -ne 6 ]
then
   echo "$0 url x, y, r, tmp_png output_filename"
   echo "参数错误:请按[图片url，剪裁中心x, 剪裁中心y, 剪裁半径r, 输出文件名 ]顺序传参"
   exit 1
fi
convert -auto-orient -resize 268x360 $1 $6
jpegoptim --strip-all  $6
mv $6 ../public/
