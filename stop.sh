kill -KILL `cat log/unicorn.pid`
god terminate
pgp resque | awk '{print $2}' | xargs kill
