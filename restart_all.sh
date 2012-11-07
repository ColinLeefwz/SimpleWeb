#!/bin/bash

#see http://unicorn.bogomips.org/SIGNALS.html
kill -HUP `cat log/unicorn.pid`
god restart resque

