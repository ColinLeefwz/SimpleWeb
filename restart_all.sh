#!/bin/bash

#see http://unicorn.bogomips.org/SIGNALS.html
kill -HUP `cat log/unicorn.pid`
kill -QUIT `cat ./resque.xmpp.pid`
kill -QUIT `cat ./resque.normal.pid`
INTERVAL=0.1 PIDFILE=./resque.xmpp.pid BACKGROUND=yes QUEUE='xmpp' rake environment resque:work
INTERVAL=5 PIDFILE=./resque.normal.pid BACKGROUND=yes QUEUE='normal' rake environment resque:work


