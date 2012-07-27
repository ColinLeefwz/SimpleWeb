//根据三级分类信息“地名地址信息;行政地名;村庄级地名”计算每种子类的总数

db.runCommand({"group" : { 
"ns" : "mapabc",
$keyf : function(doc) { return {"一级分类" : doc.type.split(";")[0]}; },
"initial" : {count : 0}, 
"$reduce" : function(doc, acc) {
 acc.count += 1
 var ts = doc.type.split(";")
 var ts1 = ts[1]
 var ts2 = ts[1]+";"+ts[2]
 if(acc[ts1]){
  acc[ts1] += 1
 }else{
  acc[ts1] = 1
 }
 if(acc[ts2]){
  acc[ts2] += 1
 }else{
  acc[ts2] = 1
 }
},
"condition" : {"city" : "0571"}
}})
