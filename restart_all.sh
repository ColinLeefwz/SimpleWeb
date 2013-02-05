#!/bin/bash

#see http://unicorn.bogomips.org/SIGNALS.html
kill -KILL `cat log/unicorn.pid`
unicorn -D -E production -c unicorn.conf.rb
./restart_resque.sh
