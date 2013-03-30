ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# Setup in-memory test server for Riak


require 'ripple/test_server'



class ActiveSupport::TestCase


#  setup { Ripple::TestServer.setup }
#  teardown { Ripple::TestServer.clear }


  def shop_login(shop_id)
    @request.session[:shop_id] = Shop.find_by_id(shop_id).id
  end

  def oauth_login(uid)
   
  end

  def db_connection
    db_config = YAML.load(File.open(Rails.root.to_s+"/config/mongoid.yml"))['test']['sessions']['default']
    host, port = db_config['hosts'].first.split(':')
    connection = Mongo::Connection.new(host, port)
    connection.db(db_config['database'])
  end

  def reload(file_name)
    db_connection.eval(File.read("#{Rails.root}/test/fixtures/#{file_name}"))
  end

  def session_user
    User.find(session[:user_id])
  end
  
  def clear_cache_all(clazz)
    clazz.only(:id).all.each {|x| x.del_my_cache}
  end
  
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...
end

