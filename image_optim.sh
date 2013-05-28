#find /home/dev/workspace/lianlian/public -size +8k -iname "*.jpg"  | xargs jpegoptim --strip-all > /dev/null
#find /home/dev/workspace/lianlian/public -size +8k -iname "*.jpeg" | xargs jpegoptim --strip-all > /dev/null
#find /home/dev/workspace/lianlian/public -size +2k  -iname "*.png" | xargs optipng > /dev/null
#find /home/dev/workspace/lianlian/public -size +8k  -iname "*.jpg" | xargs


for i in `find /mnt/lianlian/public -size +8k -cmin -10  -iname "*.jpg"`
do
    if [[ $i != *public/coupon* ]] && [[ $i != *public/uploads* ]]
        then
        jpegoptim --strip-all $i > /dev/null
        rpath=${i/'/mnt/public'/}
         fname=${rpath//\//_}
        #/mnt/Oss/oss2/osscmd put $i "oss://dface/$fname"
         uname="http://oss.aliyun.com/dface/$fname"

        if wget --spider  $uname ; then
            for html in `find /mnt/lianlian/public -name "*.html"`
            do
             rpl   "\"$rpath\"" "\"$uname\"" $html
             rpl   "'$rpath'" "\"$uname\"" $html
             rpl   "$rpath" "$uname" $html
            done

            for css in `find /mnt/lianlian/public -name "*.css"`
            do
             rpl  "..$rpath" $uname $css
             rpl  "$rpath" $uname $css
            done
        fi
    fi
done