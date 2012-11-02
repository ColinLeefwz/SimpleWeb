unicorn -D -E production -c unicorn.conf.rb
INTERVAL=0.1 PIDFILE=./resque.xmpp.pid BACKGROUND=yes QUEUE='xmpp' rake environment resque:work
INTERVAL=5 PIDFILE=./resque.normal.pid BACKGROUND=yes QUEUE='normal' rake environment resque:work
#sudo rails s -p 80
#sudo ruby script/server --port=80 
#ruby script/server_ssl &
#ruby script/runner app/check_sms.rb &

