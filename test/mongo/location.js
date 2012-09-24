db.loadServerScripts()
var shops = find_shops([ 30.280941, 120.113831 ], 1414, "122.235.138.18", ObjectId("502e6303421aa918ba000001"))
assert.eq( 4928288 , shops[0]._id , "浙江科技产业大厦" );

find_shops([ 30.281021, 120.160759 ],100,"10.63.85.108, 211.140.18.116",null,16,10)

