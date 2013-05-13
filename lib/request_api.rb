# encoding: utf-8
module RequestApi
  #调用新浪微薄api接口，
  #参数说明： m 是要定义的方法名称， log 是要写入的log文件
  #关于m 方法的参数要求。
  #一个hash里必须有的， 请求URL[:url], 请求方式：[:method] :post或:get, 请求参数:[:params],是一个hash, 发送错误邮件的标题:[:email_title],如果不传，则不发送邮件。
  #关于m方法的返回值，4次异常后返回nil 或 返回调用的接口的返回值
  def request_sina(m, log)
    cl = self
    self.define_singleton_method(m) do |hash, err_num=0 |
      url = hash[:url]
      method = hash[:method]
      begin
        JSON.parse method == :post ? RestClient.post(url, hash[:params]) : RestClient.get(url+ "?" + hash[:params].to_param)
      rescue
        err_num += 1
        log.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} #{cl}.#{m} #{method} #{url + "?" + hash[:params].to_param}错误#{err_num}次. #{$!}" if log
        if err_num == 4
          Emailer.send_mail("#{hash[:email_title]}","#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} #{cl}.#{m} #{method} #{url + "?" + hash[:params].to_param}错误. #{$!}").deliver unless hash[:email_title].nil?
          return
        end
        sleep err_num * 20
        return send(m, hash,err_num)
      end
    end
  end
  module TaoBaoIP
    def self.fetch_info(ip, err_num=0)
      begin
        uri = "http://ip.taobao.com/service/getIpInfo.php?ip=" + ip
        JSON.parse(RestClient.get(uri))
      rescue
        return if (err_num += 1)==4
        sleep err_num * 10
        return fetch_info(ip,err_num)
      end
    end

    def self.fetch_city(ip)
      fetch_info(ip)['data']['city']
    rescue
      nil
    end

  end
end
