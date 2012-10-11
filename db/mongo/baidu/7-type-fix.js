db.baidu_type_count.find({count:{$lt:16},type:/]]/}).forEach(function(x){
    var from = x.type.indexOf("[[");
    var to = x.type.lastIndexOf("]]");
    var ntype = x.type.substring(from,to+2);
    //print(ntype+"\t:\t"+x.type);
    db.baidu.update({type:x.type},{$set:{type:ntype}},false,true);
})

