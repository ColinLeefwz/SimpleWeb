var nonch = new RegExp("[^一-龥0-9a-zA-Z]", "g");
db.mapabc.find().forEach(function(x){
	var m = x.name.match(nonch);
	if(m) m.forEach(function(x,i,a){print(x)})
})

