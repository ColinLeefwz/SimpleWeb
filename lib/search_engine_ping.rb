# To change this template, choose Tools | Templates
# and open the template in the editor.

module SearchEnginePing
  URLS = ["http://ping.baidu.com/ping/RPC2","http://blogsearch.google.com/ping/RPC2"]

  def self.ping_all(article_url)
    URLS.each{|url| ping(url,article_url)}
  end


  def self.ping(ping_url, article_url)
    url = URI.parse(ping_url)
    http = Net::HTTP.new(url.host,url.port)
    req_headers= {
      'Content-Type' => 'text/xml; charset=utf-8'
    }
    req_body =<<EOF
 <?xml version=""1.0"" encoding=""UTF-8""?>
 <methodCall>
<methodName>weblogUpdates.ping</methodName>
<params>
<param>
<value>
<string>#{article_url}</string>
</value>
</param>
<param>
<value>
<string>#{article_url}</string>
</value>
</param>
</params>
</methodCall>
EOF
    begin
      res = http.request_post(url.path, req_body , req_headers)
      puts res.body
    rescue
    end
  end
end
