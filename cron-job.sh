#!/bin/bash
cd /mnt/lianlian
/mnt/mongodb/bin/mongo 127.0.0.1/dface /mnt/lianlian/db/mongo/checkin_day.js
/mnt/mongodb/bin/mongo 127.0.0.1/dface /mnt/lianlian/db/mongo/checkin_shop_stat.js
/mnt/mongodb/bin/mongo 127.0.0.1/dface /mnt/lianlian/db/mongo/checkin_ip_stat.js
/mnt/mongodb/bin/mongo 127.0.0.1/dface /mnt/lianlian/db/mongo/user_day.js
/mnt/mongodb/bin/mongo 127.0.0.1/dface /mnt/lianlian/db/mongo/checkin_user_stat.js
/mnt/mongodb/bin/mongo 127.0.0.1/dface /mnt/lianlian/db/mongo/checkin_loc_acc.js
/mnt/.rvm/bin/ruby script/rails r  'Checkin.clear_yesterday_redis'
/mnt/.rvm/bin/ruby script/rails r  'CheckinShopStat.init_user_count'
/mnt/.rvm/bin/ruby script/rails r db/mongo/ip_info.rb

