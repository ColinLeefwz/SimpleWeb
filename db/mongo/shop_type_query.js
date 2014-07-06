/*
db.mapabc2.update({type:"餐饮服务;冷饮店;冷饮店"},{$set:{t:3}},false,true)

db.collection.update( criteria, objNew, upsert, multi )

criteria - query which selects the record to update;
objNew - updated object or $ operators (e.g., $inc) which manipulate the object
upsert - if this should be an "upsert" operation; that is, if the record(s) do not exist, insert one. Upsert only inserts a single document.
multi - indicates if all documents matching criteria should be updated rather than just one. Can be useful with the $ operators below.

*/

db.mapabc2.find({t:2}).count()
db.runCommand({"group" : {
"ns":"mapabc2",
"key":"t",
"initial":{"t0":0,"t1":0,"t2":0,"t3":0,"t4":0,"t5":0,"t6":0},
"$reduce" : function(doc, prev) {
 if(doc.t==null) prev.t0 +=1;
 else{
  prev["t"+doc.t] +=1;
 }
}
}})
