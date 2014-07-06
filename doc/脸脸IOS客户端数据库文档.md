脸脸IOS客户端Sqlite数据库文档
============

######IPhone客户端

####**主要说明**
+ 采用Sqlite3数据库来存储关系型数据，IOS无其他类型嵌入式据库可选
+ 数据库不存储个人信息数据、devicetoken、httpAddress、sessionId、版本信息等
+ 数据可升级可以采用比对版本信息后移出某表格数据，然后新建表格，填入数据，再删除原表的方法
+ 数据库操作都在主线程下
+ 每个登陆后的用户简历一个新的数据库
+ 数据库文件在homeDirectory的document目录下，可用sqlite工具打开

####**主要表格**
######  blacklist
建表语句
> create table if not exists blacklist(bk_uid text primary key,bk_time integer,bk_ext1 text,bk_ext2 text,bk_exi1 integer,bk_exi2 integer);

字段类型/用途说明
+ bk_uid 文本 主键  必填 ***黑名单里的用户id*** 
+ bk_time 数字 非必填 ***什么时候被添加的***

######  coupon
建表语句
> create table if not exists coupon(id integer primary key autoincrement,pon_id text,pon_title text,pon_shopname text,pon_fromjid text,pon_time integer,pon_isused integer,pon_isread integer,pon_status integer,pon_ext1 text,pon_ext2 text,pon_ext3 text,pon_ext4 text,pon_exi1 integer,pon_exi2 integer,pon_exi3 integer,pon_exi4 integer); integer,bk_exi2 integer);

字段类型/用途说明
+ pon_id 文本 主键  必填 ***优惠券的id*** 
+ pon_title 文本 非必填 ***优惠券名字***
+ pon_shopname 文本 非必填  ***发布优惠券的商店名字*** 
+ pon_fromjid 文本 非必填 ***发布优惠券的商店的jid***
+ pon_time 数字 非必填 ***有效时间*** 
+ pon_isused 数字 非必填 ***是否使用过***
+ pon_isread 数字 非必填 ***是否被用户查看过, 被select语句查过后该值置为1*** 
+ pon_status 数字 非必填 ***状态***

######  shop
建表语句
> create table if not exists shop(s_sid text primary key,s_jid text,s_name text,s_phone text,s_address text,"
	"s_type integer,s_usercount integer,s_malecount integer,s_femalecount integer,s_ext1 text,s_ext2 text,s_ext3 text,s_ext4 text,s_ext5 text,s_exi1 integer,s_exi2 integer,s_exi3 integer,s_exi4 integer,s_exi5 integer);

字段类型/用途说明
+ s_sid 文本 必填 ***商家的id*** 
+ s_jid 文本 非必填 ***商家的jid***
+ s_name 文本 非必填 ***商家名字*** 
+ s_phone 文本 非必填 ***并没有使用的字段***
+ s_address  非必填 ***没有使用的字段*** 
+ s_type 数字 非必填 ***商家类型：餐馆，酒店等***
+ s_usercount 数字 非必填 ***现场的TA的人数*** 
+ s_malecount 数字 非必填 ***男的人数，已经停用***
+ s_femalecount 数字 非必填 ***女的人数，已经停用***

######  message
建表语句
> create table if not exists message(id integer primary key autoincrement,mes_id text,mes_from text,"
	"mes_to text, con_order text, df_uid text,mes_content text,mes_img_id text,mes_img_path text,mes_postbyme integer,mes_time integer,mes_status integer,mes_ext1 text,mes_ext2 text,mes_ext3 text,mes_ext4 text,mes_ext5 text,mes_exi1 integer,mes_exi2 integer,mes_exi3 integer,mes_exi4 integer,mes_exi5 integer);

字段类型/用途说明
+ mes_id 文本 唯一键  必填 ***消息的id*** 
+ mes_from 文本 非必填 ***消息发送者的jid***
+ mes_to 文本 非必填  非必填 ***消息接受者的jid*** 
+ con_order 文本 外键 非必填 ***消息所在对话的外键，对应convesation表的主键，多对一结构***
+ df_uid  非必填 ***消息发送者的uid*** 
+ mes_content 文本 非必填 ***消息内容***
+ mes_img_id 文本 非必填 ***如果该消息是图片消息，表示图片的id，否则是空*** 
+ mes_img_path 文本 非必填 ***如果该消息是图片消息，表示图片的缓存本地路径，否则是空***
+ mes_postbyme 数字 非必填 ***是不是我发送出去的消息***
+ mes_time 数字 非必填 ***消息发送或者接受的时间***
+ mes_status 数字 非必填 ***已发送消息的状态，已读、送达，发送中3个状态***

######  convesation
#####会话表用于单独保存用户的会话，主键是message表中的con_order外键
建表语句
> create table if not exists conversation(con_order text primary key,con_lasttext text,con_opponent text,con_unreadcount integer,con_owner text,con_time integer,con_ext1 text,con_ext2 text,con_ext3 text,con_exi1 integer,con_exi2 integer,con_exi3 integer);

字段类型/用途说明
+ con_order 文本 主键  必填 ***会话的order，order是根据收发着的jid算出来的*** 
+ con_lasttext 文本 非必填 ***收到属于该会话的最后一条消息的内容文本***
+ con_opponent 文本 非必填 ***会话的除开自己对方的jid*** 
+ con_unreadcount 数字 非必填 ***消没有阅读的数字，每收到一条消息加1，点击后置为0***
+ con_owner  非必填 ***基本无用的字段，就是自己的jid*** 
+ con_time 文本 非必填 ***最后收到消息的时间***

######  user
建表语句
> create table if not exists user(usr_uid text primary key,usr_jid text,usr_sinauid text,usr_name text,usr_thumburl text,usr_middleurl text,usr_imageurl text,usr_sign text,usr_sex integer,usr_birth integer,usr_costellation text,usr_job text,usr_jobtype integer,usr_hobby text,usr_photocount integer,usr_regtime integer,usr_lastappeartime text,usr_lastscene text,usr_isfollowed integer default 0,usr_isfollowing integer default 0,usr_issinav integer,usr_sinainfo text,usr_istouched integer,usr_ext1 text,usr_ext2 text,usr_ext3 text,usr_ext4 text,usr_exi1 integer,usr_exi2 integer,usr_exi3 integer,usr_exi4 integer);

字段类型/用途说明
+ usr_uid 文本 主键  必填 ***用户的id*** 
+ usr_jid 文本 非必填 ***用户jid***
+ usr_sinauid 文本 非必填 ***用户sina的id*** 
+ usr_name 文本 非必填 ***用户名字***
+ usr_thumburl 非必填 ***用户小头像的url，比如聊天室和对话页面*** 
+ usr_middleurl 文本 非必填 ***用户中头像url，比如相册***
+ usr_imageurl 文本 非必填 ***用户大头像的url，查看头像的原图***
+ usr_sign 文本 非必填 ***用户自己的签名*** 
+ usr_sex 数字 非必填 ***用户性别0，1，2***
+ usr_birth 数字 非必填 ***生日*** 
+ usr_costellation 文本 非必填 ***星座***
+ usr_job 文本 非必填 ***自定义的工作***
+ usr_jobtype 数字 非必填 ***选择的工作类型*** 
+ usr_lastappeartime 文本 非必填 ***没有用到***
+ usr_lastscene 文本 非必填 ***最后出现的时间+最后出现的位置信息*** 
+ usr_isfollowed 数字 非必填 ***我有没有关注这个用户***
+ usr_isfollowing 数字 非必填 ***这个用户是不是我的粉丝***
+ usr_issinav 数字 非必填 ***是不是sina的加v用户***
+ usr_sinainfo 文本 非必填 ***sina加v用户的认证信息***
+ usr_istouched 数字 非必填 ***没用到的字段***

######  friend 
#####该表记录所有的好友的uid信息，具体信息外键到user表查询，该表没有单独插入和删除操作，队列形式每次写入前删除搜索数据批量写入
建表语句
> create table if not exists friend(id integer primary key autoincrement,usr_uid text);

字段类型/用途说明
+ usr_uid 文本 非必填 ***用户的id*** 

######  follow 
#####该表记录所有的关注的uid信息，具体信息外键到user表查询，该表没有单独插入和删除操作，队列形式每次写入前删除搜索数据批量写入

建表语句
> create table if not exists follow(id integer primary key autoincrement,usr_uid text);

字段类型/用途说明
+ usr_uid 文本 非必填 ***用户的id*** 

######  c_fan
##### 该表为缓存数据，丢失也没关系，缓存数据也可以不写在数据库内，该表内的字段几乎全部和user表重复，缓存只缓存20条
建表语句 
> create table if not exists c_fan(id integer primary key autoincrement,usr_uid text,usr_jid text,usr_type integer,usr_sinauid text,usr_qqopenid text,usr_name text,usr_thumburl text,usr_middleurl text,usr_imageurl text,usr_sign text,usr_sex integer,usr_birth integer,usr_costellation text,usr_job text,usr_jobtype integer,usr_hobby text,usr_photocount integer,usr_regtime integer,usr_lastappeartime text,usr_lastscene text,usr_isfollowed integer,usr_isfollowing integer,usr_issinav integer,usr_sinainfo text,usr_istouched integer,py_original text,py_pinyin text,py_shuangpin text,usr_ext1 text,usr_ext2 text,usr_ext3 text,usr_ext4 text,usr_exi1 integer,usr_exi2 integer,usr_exi3 integer,usr_exi4 integer);

字段类型/用途说明
+ py_original 文本 非必填 ***用户名字***
+ py_pinyin 文本 非必填 ***用户名字的拼音***
+ py_shuangpin 文本 非必填 ***用户名字的双拼，拼音和双拼信息是为了查询，支持拼音查询和双拼查询***