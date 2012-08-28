#!/bin/bash

#see http://unicorn.bogomips.org/SIGNALS.html
kill -HUP `cat log/unicorn.pid`

#mysql_zap -f -KILL 3040
#nohup /home/dooo/.rvm/bin/ruby script/rails s -p 3040 &

