#!/bin/bash
while pgrep -f resque-1
do 
 echo 'killing resque...'
 sleep 1
 pkill -QUIT -f resque-1
done
god restart resque

