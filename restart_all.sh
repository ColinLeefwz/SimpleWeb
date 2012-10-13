#!/bin/bash

#see http://unicorn.bogomips.org/SIGNALS.html
kill -HUP `cat log/unicorn.pid`
kill -QUIT `cat ./resque.pid`
INTERVAL=1 PIDFILE=./resque.pid BACKGROUND=yes QUEUE='*' rake environment resque:work

#mysql_zap -f -KILL 3040
#nohup /home/dooo/.rvm/bin/ruby script/rails s -p 3040 &

