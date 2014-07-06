
db.checkins.update({},{$unset:{"shop_name": 1}, $rename:{"shop_id":"sid", "user_id": "uid", "accuracy" : "acc", "gender": "sex"} }, false, true );

