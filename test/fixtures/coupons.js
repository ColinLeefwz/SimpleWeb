db.coupons.remove();

db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a412e1'),
    shop_id: 1,
    t2: 1,
    name: '测试每日优惠券.',
    users: [],
    desc: "每日签到优惠券测试",
    rule: '0'
})

db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a4121e'),
    shop_id: 2,
    t2: 1,
    users: [],
    name: '测试每日优惠券2.',
    desc: "商家id是2的每日签到优惠券测试",
    rule: '0'
})
db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a4122e'),
    shop_id: 2,
    users: [],
    t2: 1,
    name: '测试前2名优惠券2.',
    desc: "商家id是2的每日签到优惠券测试",
    rule: 1,
    rulev: 2
})

db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a412e2'),
    shop_id: 1,
    t2: 1,
    users: [],
    name: '测试前2名优惠券',
    desc: "每日前2名签到优惠",
    rule: 1,
    rulev: 2
})

db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a412e3'),
    shop_id: 1,
    t2: 1,
    users: [],
    name: '测试首次优惠券',
    desc: "新用户首次签到优惠",
    rule: 2
})

db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a412e4'),
    shop_id: 1,
    t2: 1,
    users: [],
    name: '测试累计优惠券',
    desc: "累计3次签到优惠",
    rule: 3,
    rulev: 3
})

db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a412e5'),
    shop_id: 1,
    t2: 2,
    rule: 0,
    users: [],
    name: '测试分享优惠券',
    desc: "分享类测试优惠",
    text: '我们一起分享吧'
})

db.coupons.insert({
    _id: ObjectId('507fc5bfc9ad42d756a412e6'),
    shop_id: 1,
    t2: 2,
    rule: 1,
    users: [],
    name: '测试分享优惠券',
    desc: "分享类测试优惠",
    text: '我们一起分享吧'
})

