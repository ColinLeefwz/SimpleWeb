#!/bin/bash
if [ $# -ne 3 ]
then
   echo "$0 title output_filename"
   echo "参数错误:请按[编号 原图地址  最终生成的图片保存的路径 图片路径]顺序传参"
   exit 1
fi

convert -quality 70 -font 'msyh.ttf' -fill "gray" -pointsize 15 -kerning 1 -draw "text 500,220\"${1}\"" $2 $3