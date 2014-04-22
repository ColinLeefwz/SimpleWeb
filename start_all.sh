#unicorn -D -E production -c unicorn.conf.rb
bundle exec puma  -C /mnt/lianlian/config/puma.rb
god -c god/all.god 

