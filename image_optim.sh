dir=/mnt/lianlian/public
#dir=/home/dev/workspace/lianlian/public
jpgs=`find $dir -size +8k -cmin -1 -iname "*.jpg"`
jpegs=`find $dir -size +8k -cmin -1 -iname "*.jpeg"`
pngs=`find $dir -size +2k -cmin -1 -iname "*.png"`
html=`find $dir -name "*.html"`
css=`find $dir/stylesheets -name "*.css"`

for i in $jpgs
do
    if [[ $i = *public/images* ]] || [[ $i = *public/help* ]]
        then
        jpegoptim --strip-all $i > /dev/null
        mogrify -strip  $i
        rpath=${i/"$dir/"/}
         fname=${rpath//\//_}
        /mnt/Oss/oss2/osscmd put $i "oss://dface/$fname"
         uname="http://oss.aliyuncs.com/dface/$fname"

        if wget --spider  $uname ; then
            rpl "/$rpath" "$uname" $html
            rpl "$rpath" "$uname"  $html
            rpl "../$rpath" "$uname" $css
            rpl "/$rpath" "$uname" $css
            rpl "$rpath" "$uname" $css
        fi
    fi
done

for i in $jpegs
do
     if [[ $i = *public/images* ]] || [[ $i = *public/help* ]]
        then
        jpegoptim --strip-all $i > /dev/null
        mogrify -strip  $i
        rpath=${i/"$dir/"/}
         fname=${rpath//\//_}
        /mnt/Oss/oss2/osscmd put $i "oss://dface/$fname"
         uname="http://oss.aliyuncs.com/dface/$fname"

        if wget --spider  $uname ; then
            rpl "/$rpath" "$uname" $html
            rpl "$rpath" "$uname"  $html
            rpl "../$rpath" "$uname" $css
            rpl "/$rpath" "$uname" $css
            rpl "$rpath" "$uname" $css
        fi
    fi
done

for i in $pngs
do
    if [[ $i = *public/images* ]] || [[ $i = *public/help* ]]
        then
        optipng $i > /dev/null
        mogrify -strip $i
        rpath=${i/"$dir/"/}
         fname=${rpath//\//_}
        /mnt/Oss/oss2/osscmd put $i "oss://dface/$fname"
         uname="http://oss.aliyuncs.com/dface/$fname"

        if wget --spider  $uname ; then
            rpl "/$rpath" "$uname" $html
            rpl "$rpath" "$uname"  $html
            css=`find $dir -name "*.css"`
            rpl "../$rpath" "$uname" $css
            rpl "/$rpath" "$uname" $css
            rpl "$rpath" "$uname" $css
        fi
    fi
done