Resque::Server.use(Rack::Auth::Basic) do |user, password|
  user == "dface.cn" && password == "lianlian"
end

