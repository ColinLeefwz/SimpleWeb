#!/bin/bash
sudo mongod --fork --logpath=/var/log/mongo.log
sudo haproxy -f /Users/ylt/lianlian/haproxy.development.cfg
nohup redis-server&
memcached -d

