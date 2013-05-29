#图片失真处理后上传
#参数说明  $1 图片的绝对路径 $2 保留的质量因子
#例：./image_quality.sh /mnt/lianlian/public/images/ad5.jpg 20 图片将失真80% 保留20%

dir=/mnt/lianlian/public
i=$1
mogrify -quality $2  $1
rpath=${i/"$dir/"/}
fname=${rpath//\//_}
/mnt/Oss/oss2/osscmd put $i "oss://dface/$fname"
