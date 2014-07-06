db.shop_notices.remove();
db.shop_notices.insert({ 
    _id: ObjectId('507fc5bfc9ad42d756a412e4'),
    shop_id: 3,
    title: '测试有效公告',
    ord: 1,
    effect: true
})

db.shop_notices.insert({
    _id: ObjectId('507fc5ffc9ad42d756a412e8'),
    shop_id: 3,
    title: '测试过期公告',
    ord: 3,
    effect: false
})

db.shop_notices.insert({
    shop_id: 2,
    title: '商家2的公告1',
    ord: 1,
    effect: true
})

db.shop_notices.insert({
    shop_id: 2,
    title: '商家2的公告2',
    ord: 3,
    effect: true
})

