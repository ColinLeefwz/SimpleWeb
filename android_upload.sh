#rm /mnt/lianlian/public/dface.apk
#mv /mnt/dface-release${1}.apk /mnt/lianlian/public/dface${1}.apk
#/mnt/Oss/oss2//osscmd deleteallobject oss://dface/dface.apk
/mnt/Oss/oss2/osscmd put /mnt/lianlian/public/dface${1}.apk oss://dface/dface${1}.apk --content-type=application/octet-stream
redis-cli -h 10.200.141.172 set android_version ${1}