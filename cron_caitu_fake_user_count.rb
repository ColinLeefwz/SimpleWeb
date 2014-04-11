#印象城人数处理，每分钟增加1人
#* * * * * cd /mnt/lianlian && RAILS_ENV=production /mnt/.rvm/bin/ruby script/rails r cron_caitu_fake_user_count.rb

today = Time.now
hour = today.hour
return if (hour>=22 || hour<10)
$redis.set("suac21831686",$redis.get("suac21831686").to_i+1)
