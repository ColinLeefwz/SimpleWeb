db.coupons.remove();
db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a412e1'),
    shop_id: 1,
    name: '测试优惠券1',
    desc: "测试优惠券1详情,规则只能下载一次",
    ratio: 100,
    rule: '0'
})

db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a412e2'),
    shop_id: 1,
    name: '测试优惠券1',
    desc: "测试优惠券1详情,规则只能有一个未使用",
    ratio: 100,
    rule: 1
})

db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a412e3'),
    shop_id: 1,
    name: '测试优惠券1',
    desc: "测试优惠券1详情,规则无限制下载",
    ratio: 100,
    rule: 2
})

db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a412e4'),
    shop_id: 1,
    name: '测试优惠券',
    desc: "规则无限制下载,测试优惠券只推送最后一张",
    ratio: 100,
    rule: 2
})


