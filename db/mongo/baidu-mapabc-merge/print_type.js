db.baidu_type_count2.find().sort({type:1}).forEach(function(x){
	print(x.type+"\t"+x.c);
})

