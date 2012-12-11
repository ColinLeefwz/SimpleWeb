#!/bin/bash
stime=`date +"%Y-%m-%d %H:%M:%S"`

cd /mnt/lianlian
/mnt/mongodb/bin/mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/checkin_day.js
/mnt/mongodb/bin/mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/checkin_shop_stat.js
/mnt/mongodb/bin/mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/checkin_ip_stat.js
/mnt/mongodb/bin/mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/user_day.js
/mnt/mongodb/bin/mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/checkin_user_stat.js
/mnt/mongodb/bin/mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/checkin_loc_acc.js
/mnt/mongodb/bin/mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/checkin_user_many.js

/mnt/.rvm/bin/ruby script/rails r  'Checkin.clear_yesterday_redis'
/mnt/.rvm/bin/ruby script/rails r  'CheckinShopStat.init_user_count'
/mnt/.rvm/bin/ruby script/rails r db/mongo/ip_info.rb

etime=`date +"%Y-%m-%d %H:%M:%S"`
stime_int=`date -d  "$stime" +%s`
etime_int=`date -d  "$etime" +%s`
inttt=`expr $etime_int - $stime_int`
echo $stime"开始执行cron,总花费时间："$inttt'秒'>>log/cron-job.log
