//根据三级分类信息“地名地址信息;行政地名;村庄级地名”计算每种子类的总数

map = function() {
 var acc = {count:1};
 var ts = this.type.split(";");
 var ts1 = ts[1];
 var ts2 = ts[1]+";"+ts[2];
 acc[ts1]=1;acc[ts2]=1;
 emit(ts[0], acc);
};

reduce = function(key, emits) {
 var acc = new Object();
 acc.count = 0;
 for ( var i=0; i<emits.length; i++ ){
  acc.count += 1;
  for(var p in emits[i]){
   if(acc[p]) acc[p] += 1;
   else acc[p]=1;
  }
 }
 return acc;
}

db.mapabc.mapReduce(map,reduce,{"query" : {"city" : "0571"}, out: { replace : "mr"}})
