#!/bin/bash
sudo mongod --fork --logpath=/var/log/mongo.log
sudo haproxy -f ./haproxy.development.cfg
redis-server /usr/local/etc/redis.conf


#设置www.dface.cn指向本机后，就可以使用发布系统的网址http://www.dface.cn来访问开发环境。

