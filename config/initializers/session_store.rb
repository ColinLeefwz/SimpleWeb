# Be sure to restart your server when you modify this file.

<<<<<<< HEAD
Prodygia::Application.config.session_store :cookie_store, key: '_prodygia_session'
=======
#Lianlian::Application.config.session_store :cookie_store, :key => '_lianlian_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")

if Rails.env=="production"
  Lianlian::Application.config.session_store :redis_store, :servers => {host: '10.200.141.172'}
else
  Lianlian::Application.config.session_store :redis_store
end
    
Lianlian::Application.config.middleware.delete 'Rack::Cache'   # 整页缓存，用不上
Lianlian::Application.config.middleware.delete 'Rack::Lock'    # 多线程加锁，多进程模式下无意义
Lianlian::Application.config.middleware.delete 'Rack::Runtime' #记录X-Runtime
Lianlian::Application.config.middleware.delete 'ActionDispatch::RequestId' # 记录X-Request-Id（方便查看请求在群集中的哪台执行）
Lianlian::Application.config.middleware.delete 'ActionDispatch::RemoteIp'  # IP SpoofAttack
Lianlian::Application.config.middleware.delete 'ActionDispatch::Callbacks' # 在请求前后设置callback
Lianlian::Application.config.middleware.delete 'ActionDispatch::Head'      # 如果是HEAD请求，按照GET请求执行，但是不返回body
Lianlian::Application.config.middleware.delete 'Rack::ConditionalGet'      # HTTP客户端缓存才会使用
Lianlian::Application.config.middleware.delete 'Rack::ETag'    # HTTP客户端缓存才会使用
Lianlian::Application.config.middleware.delete 'ActionDispatch::BestStandardsSupport' # 设置X-UA-Compatible, 在nginx上设置
Lianlian::Application.config.middleware.delete 'Rack::Mongoid::Middleware::IdentityMap'
>>>>>>> b8c272e31d97492bb030400d7034cb2d7a03ce34
