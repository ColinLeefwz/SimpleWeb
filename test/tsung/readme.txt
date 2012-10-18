
下载地址：http://tsung.erlang-projects.org/dist/tsung-1.4.2.tar.gz

替换src/tsung目录下的ts_jabber_common.erl文件，原文件登录成功后错误的发送iq/bind消息。主要原因是少了下面的内容：
"<stream:stream xmlns='jabber:client' xmlns:stream='http://etherx.jabber.org/streams' version='1.0' to='dface.cn'>"

参见login_process_err.txt的日志。
所以我增加了<request><jabber type="auth_sasl_bind0" ack="local"></jabber></request>用以发送上面的内容。

运行测试：
tsung -f test.xml start

tsung status

进入log目录，运行tsung_stats.pl
/opt/local/lib/tsung/bin/tsung_stats.pl
