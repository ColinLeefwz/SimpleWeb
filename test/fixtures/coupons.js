db.coupons.remove();
db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a412e1'),
    shop_id: 1,
    t2: 1,
    name: '测试优惠券1',
    desc: "测试优惠券1详情,每日签到优惠",
    rule: '0'
})

db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a412e2'),
    shop_id: 1,
    t2: 1,
    name: '测试优惠券1',
    desc: "测试优惠券1详情,每日前2名签到优惠",
    rule: 1,
    rulev: 2
})

db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a412e3'),
    shop_id: 1,
    t2: 1,
    name: '测试优惠券1',
    desc: "测试优惠券1详情,新用户首次签到优惠",
    rule: 2
})

db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a412e4'),
    shop_id: 1,
    t2: 1,
    name: '测试优惠券',
    desc: "规则无限制下载,累计3次签到优惠",
    rule: 3,
    rulev: 3
})

db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a412e4'),
    shop_id: 1,
    t2: 2,
    name: '测试优惠券',
    desc: "分享类测试优惠",
    text: '我们一起分享吧'
})


