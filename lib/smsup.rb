require 'savon'
require 'dalli'

dc = Dalli::Client.new("10.200.141.171:11211")

#host="211.147.239.62:8480"
#host="211.147.239.62:9070"
host="211.147.239.62:9088" #ok

client = Savon.client(wsdl: "http://#{host}/services/EsmsService?wsdl")
#client.operations

(1..9999).each do |x|
  resp = client.call(:get_mo_msg, message: { account: "cadmin@zjll", password:"Dface.cn1234" })
  str = resp.body[:get_mo_msg_response][:get_mo_msg_return]
  if str.class == String
    arr = str.split("[")
    phone = arr.find{|x| x.match /^srcterminalid/}["srcterminalid]".size..-1]
    txt = arr.find{|x| x.match /^msgcontent/}["msgcontent]".size..-1]
    dc.set("SMSUP#{phone}", 1)
  end
  t = ENV["SMS_CHECK_INTEVAL"].to_i
  t = 3 if t==0
  sleep t
end

exit

#ret = client.call(:get_remain_fee, message: { account: "cadmin@zjll", password:"Dface.cn1234" })
#ret = client.call(:get_account_info, message: { account: "cadmin@zjll", password:"Dface.cn1234" })
#ret = client.call(:get_config_info, message: { account: "cadmin@zjll", password:"Dface.cn1234" })
#ret = client.call(:get_mobile_heads, message: { account: "cadmin@zjll", password:"Dface.cn1234" })
#ret = client.call(:get_price_by_type, message: { account: "cadmin@zjll", password:"Dface.cn1234" })
