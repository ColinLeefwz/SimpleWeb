#!/bin/bash
mysql_zap -f -KILL 3040
nohup /opt/ruby-enterprise-1.8.7-2010.01/bin/ruby script/rails s -p 3040 &

