#!/bin/bash
cd /mnt/lianlian
master=`mongo --quiet  10.132.36.138/dface is_master.js`
echo $master

mongo $master/dface /mnt/lianlian/db/mongo/user_hour.js

