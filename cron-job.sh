#!/bin/bash
stime=`date +"%Y-%m-%d %H:%M:%S"`

cd /mnt/lianlian
mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/checkin_day.js
sleep 1
mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/checkin_shop_stat.js
sleep 1
#mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/checkin_ip_stat.js
mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/user_day.js
sleep 1
mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/checkin_user_stat.js
sleep 1
mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/checkin_loc_acc.js
sleep 1
#mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/checkin_user_many.js
mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/user_city_day.js
sleep 1
mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/coupon_day_stat.js
sleep 1
mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/user_device_stat.js
sleep 1
mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/photo_day_stat.js
sleep 1
mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/user_day_active.js
sleep 1
mongo 10.135.44.107/dface /mnt/lianlian/db/mongo/activity_shop_day_stat.js
sleep 10

/mnt/.rvm/bin/ruby script/rails r  'Checkin.clear_yesterday_redis'
/mnt/.rvm/bin/ruby script/rails r  'CheckinShopStat.init_user_count'
sleep 1
/mnt/.rvm/bin/ruby script/rails r  'User.fix_head_logo_err'
/mnt/.rvm/bin/ruby script/rails r  'Photo.fix_error(true)'
/mnt/.rvm/bin/ruby script/rails r  'UserLogo.fix_error(true)'
#/mnt/.rvm/bin/ruby script/rails r db/mongo/ip_info.rb
/mnt/.rvm/bin/ruby script/rails r  'UserActive.do_count'

etime=`date +"%Y-%m-%d %H:%M:%S"`
stime_int=`date -d  "$stime" +%s`
etime_int=`date -d  "$etime" +%s`
inttt=`expr $etime_int - $stime_int`
echo $stime"开始执行cron,总花费时间："$inttt'秒'>>log/cron-job.log
