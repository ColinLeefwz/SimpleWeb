rm /mnt/lianlian/public/dface.apk
cp /mnt/dface-release.apk /mnt/lianlian/public/dface.apk
/mnt/Oss/oss2//osscmd deleteallobject oss://dface/dface.apk
/mnt/Oss/oss2/osscmd put /mnt/lianlian/public/dface.apk oss://dface/dface.apk --content-type=application/octet-stream
