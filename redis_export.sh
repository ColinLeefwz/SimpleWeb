tar -jcv -f ~/redis_export.tar.bz2 /var/lib/redis/6379/dump.rdb
/mnt/Oss/oss2/osscmd put ~/redis_export.tar.bz2 oss://lianlian/redis_export.tar.bz2

