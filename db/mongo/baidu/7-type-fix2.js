db.baidu_type_count2.find({c:{$lt:16},type:/;/}).forEach(function(x){
    var from = x.type.indexOf(";");
    var ntype = x.type.substring(0,from);
    //print(ntype+"\t:\t"+x.type);
    db.baidu.update({type:x.type},{$set:{type:ntype}},false,true);
})

