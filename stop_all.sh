#kill -KILL `cat log/unicorn.pid`
bundle exec pumactl -P /mnt/lianlian/log/puma.pid stop
god terminate
pgp resque | awk '{print $2}' | xargs kill
