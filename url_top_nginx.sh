tail -n 10000 /var/log/nginx/www.access.log | ruby -ne 'arr=$_.split();puts arr[6]' | sort | uniq -c | sort -nr | head -n 15

tail -n 10000 /var/log/nginx/www.access.log | ruby -ne 'arr=$_.split();puts arr[6].scan(/[^?]+[\?]?/)[0]' | sort | uniq -c | sort -nr | head -n 15

