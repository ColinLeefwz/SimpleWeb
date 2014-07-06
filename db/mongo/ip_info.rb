ips = CheckinIpStat.where({:data => {'$exists' => false}})

ips.each do |ip|
  begin
    uri = "http://ip.taobao.com/service/getIpInfo.php?ip=" + ip.id
    ipinfo_hash = JSON.parse(RestClient.get(uri))
    next if ipinfo_hash['code']== 1
    data = ipinfo_hash['data']
    data.delete('ip')
    ip.data = data
    ip.save!
  rescue
    next
  end
end