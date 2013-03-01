#!/bin/bash
god stop resque
while pgrep -f resque-1
do 
 echo 'killing resque...'
 sleep 1
 pkill -signal QUIT -f resque-1
done
god start resque

