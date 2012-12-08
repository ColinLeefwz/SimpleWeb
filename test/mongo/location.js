db.loadServerScripts();
var shops = find_shops([ 30.282204, 120.11528 ], 300, "122.235.138.18", ObjectId("502e6303421aa918ba000001"));
assert.eq( "浙江科技产业大厦" , shops[0][0].name );

