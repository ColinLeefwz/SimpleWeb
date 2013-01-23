#!/bin/bash

#see http://unicorn.bogomips.org/SIGNALS.html
kill -KILL `cat log/unicorn.pid`
god stop resque
pgp resque | awk '{print $2}' | xargs kill
sleep 2
echo `pgp resque`
unicorn -D -E production -c unicorn.conf.rb
god start resque

