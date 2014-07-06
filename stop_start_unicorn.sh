kill -KILL `cat log/unicorn.pid`
sleep 1

while true
do 
  if ps -ef | grep unicorn | grep -v grep
  then
	echo "."
	sleep 1
  else
  	echo "stop successful."
  	break
  fi
done


unicorn -D -E production -c unicorn.conf.rb
echo "start successful."
