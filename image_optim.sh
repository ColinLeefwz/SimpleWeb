#find /home/dev/workspace/lianlian/public -size +8k -iname "*.jpg"  | xargs jpegoptim --strip-all > /dev/null
#find /home/dev/workspace/lianlian/public -size +8k -iname "*.jpeg" | xargs jpegoptim --strip-all > /dev/null
#find /home/dev/workspace/lianlian/public -size +2k  -iname "*.png" | xargs optipng > /dev/null
#find /home/dev/workspace/lianlian/public -size +8k  -iname "*.jpg" | xargs

dir=/mnt/lianlian/public
jpgs=`find $dir -size +8k  -iname "*.jpg"`
jpegs=`find $dir -size +8k -cmin -1 -iname "*.jpeg"`
pngs=`find $dir -size +2k -cmin -1 -iname "*.png"`

for i in $jpgs
do
    if [[ $i != *public/coupon* ]] && [[ $i != *public/uploads* ]] && [[ $i != *public/phone* ]] && [[ $i != *public/phone2* ]]
        then
        jpegoptim --strip-all $i > /dev/null
        mogrify -strip -quality 85 $i
        rpath=${i/"$dir/"/}
         fname=${rpath//\//_}
        /mnt/Oss/oss2/osscmd put $i "oss://dface/$fname"
         uname="http://oss.aliyuncs.com/dface/$fname"

        if wget --spider  $uname ; then
            html=`find $dir -name "*.html"`
            rpl "/$rpath" "$uname" $html
            rpl "$rpath" "$uname"  $html
            css=`find $dir -name "*.css"`
            rpl "../$rpath" "$uname" $css
            rpl "/$rpath" "$uname" $css
            rpl "$rpath" "$uname" $css
        fi
    fi
done

for i in $jpegs
do
    if [[ $i != *public/coupon* ]] && [[ $i != *public/uploads* ]] && [[ $i != *public/phone* ]] && [[ $i != *public/phone2* ]]
        then
        jpegoptim --strip-all $i > /dev/null
        mogrify -strip -quality 85 $i
        rpath=${i/"$dir/"/}
         fname=${rpath//\//_}
        /mnt/Oss/oss2/osscmd put $i "oss://dface/$fname"
         uname="http://oss.aliyuncs.com/dface/$fname"

        if wget --spider  $uname ; then
            html=`find $dir -name "*.html"`
            rpl "/$rpath" "$uname" $html
            rpl "$rpath" "$uname"  $html
            css=`find $dir -name "*.css"`
            rpl "../$rpath" "$uname" $css
            rpl "/$rpath" "$uname" $css
            rpl "$rpath" "$uname" $css
        fi
    fi
done

for i in $pngs
do
    if [[ $i != *public/coupon* ]] && [[ $i != *public/uploads* ]] && [[ $i != *public/phone* ]] && [[ $i != *public/phone2* ]]
        then
        optipng $i > /dev/null
        mogrify -strip -quality 85 $i
        rpath=${i/"$dir/"/}
         fname=${rpath//\//_}
        /mnt/Oss/oss2/osscmd put $i "oss://dface/$fname"
         uname="http://oss.aliyuncs.com/dface/$fname"

        if wget --spider  $uname ; then
            html=`find $dir -name "*.html"`
            rpl "/$rpath" "$uname" $html
            rpl "$rpath" "$uname"  $html
            css=`find $dir -name "*.css"`
            rpl "../$rpath" "$uname" $css
            rpl "/$rpath" "$uname" $css
            rpl "$rpath" "$uname" $css
        fi
    fi
done