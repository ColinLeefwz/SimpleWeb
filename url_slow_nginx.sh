tail -n 10000  /home/dooo/nginx-1.2.3/build/access.log  | ruby -ne 'arr=$_.split(); print arr[-2]," ",arr.to_s,"\n"' | sort -nr | head 

