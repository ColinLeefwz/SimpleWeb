ips = CheckinIpStat.where({:city => {'$exists' => false}})

ips.each do |ip|
  begin
    uri = "http://ip.taobao.com/service/getIpInfo.php?ip=" + ip.id
    ipinfo_hash = JSON.parse(RestClient.get(uri))
    next if ipinfo_hash['code']== 1
    ip.data = ipinfo_hash['data']
    ip.save!
  rescue
    next
  end
end