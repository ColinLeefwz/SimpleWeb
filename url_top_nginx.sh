tail -n 1000 /home/dooo/nginx-1.2.3/build/access.log  | ruby -ne 'arr=$_.split();puts arr[6]' | sort | uniq -c | sort -nr | head -n 15
