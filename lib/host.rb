module Host
  Mweb = if Rails.env.production?
    "http://w.dface.cn"
  else
    "http://mweb.com"
  end
end