#find /home/dev/workspace/lianlian/public -size +8k -iname "*.jpg"  | xargs jpegoptim --strip-all > /dev/null
#find /home/dev/workspace/lianlian/public -size +8k -iname "*.jpeg" | xargs jpegoptim --strip-all > /dev/null
#find /home/dev/workspace/lianlian/public -size +2k  -iname "*.png" | xargs optipng > /dev/null
#find /home/dev/workspace/lianlian/public -size +8k  -iname "*.jpg" | xargs


for i in `find /mnt/lianlian/public -size +8k -cmin -10  -iname "*.jpg"`
do
    if [[ $i != *public/coupon* ]] && [[ $i != *public/uploads* ]]
        then
        jpegoptim --strip-all $i > /dev/null
        rpath=${i/'/mnt/lianlian/public/'/}
         fname=${rpath//\//_}
        #/mnt/Oss/oss2/osscmd put $i "oss://dface/$fname"
         uname="http://oss.aliyun.com/dface/$fname"

        if wget --spider  $uname ; then
            html=`find /mnt/lianlian/public -name "*.html"`
            $html | xargs rpl "/$rpath" "$uname"
            $html | xargs rpl "$rpath" "$uname"
            css=`find /mnt/lianlian/public -name "*.css"`
            $css | xargs rpl "$rpath" "$uname"
            $css | xargs rpl "/$rpath" "$uname"
            $css | xargs rpl "../$rpath" "$uname"
        fi
    fi
done