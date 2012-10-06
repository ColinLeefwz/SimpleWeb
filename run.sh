unicorn -D -E production -c unicorn.conf.rb
INTERVAL=1 PIDFILE=./resque.pid BACKGROUND=yes QUEUE='*' rake environment resque:work
#sudo rails s -p 80
#sudo ruby script/server --port=80 
#ruby script/server_ssl &
#ruby script/runner app/check_sms.rb &

