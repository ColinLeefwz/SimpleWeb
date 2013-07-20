#!/bin/bash

#see http://unicorn.bogomips.org/SIGNALS.html
kill -USR2 `cat log/unicorn.pid`
sleep 2

while true
do 
  if tail -n 3 log/unicorn.log | grep "worker=0 ready"
  	then
  	echo "restart successful."
  	break
  fi
  
  if tail -n 3 log/unicorn.log | grep "ERROR"
  	then
  	echo "restart has ERROR."
  	break
  fi
  echo "."
  sleep 1
done

