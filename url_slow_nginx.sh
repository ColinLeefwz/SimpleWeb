tail -n 10000 /var/log/nginx/www.access.log | ruby -ne 'arr=$_.split(); print arr[-1]," ",arr[1..-2].to_s,"\n"' | sort -nr | head -n 100
