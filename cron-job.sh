#!/bin/bash
cd /home/dooo/lianlian
/home/dooo/mongodb/bin/mongo 192.168.1.22/dface /home/dooo/lianlian/db/mongo/checkin_day.js
/home/dooo/mongodb/bin/mongo 192.168.1.22/dface /home/dooo/lianlian/db/mongo/checkin_shop_stat.js
/home/dooo/mongodb/bin/mongo 192.168.1.22/dface /home/dooo/lianlian/db/mongo/checkin_ip_stat.js
/home/dooo/.rvm/bin/ruby script/rails r  'Checkin.clear_yesterday_redis'
/home/dooo/.rvm/bin/ruby script/rails r db/mongo/ip_info.rb
