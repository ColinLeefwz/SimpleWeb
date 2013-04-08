#!/bin/bash
if [ $# -ne 4 ]
then
   echo "$0 title output_filename"
   echo "参数错误:请按[名称 详情 最终生成的图片保存的路径 上传的小图片路径]顺序传参"
   exit 1
fi
convert -quality 70 -font 'msyh.ttf' -fill "#309797" -pointsize 24 -kerning 1.5 -draw "text 232,50\"${1}\"" -fill "gray" -pointsize 20 -kerning 1 -draw "text 232,90\"${2}\"" -draw "image Over 15,17 189,189 \"${4}\""   demo.png $3
#convert -resize 290x112 $3 "${3}_2.jpg"

