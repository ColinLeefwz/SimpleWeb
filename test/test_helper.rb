ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase

  def shop_login(shop_id)
    @request.session[:shop_id] = Shop.find_by_id(shop_id).id
  end

  def oauth_login(uid)
   
  end


  def reload(file_name)
    User.collection.database.session.cluster.with_primary do |node|
      dbname = User.collection.database.name
      node.command(dbname, eval: File.read("#{Rails.root}/test/fixtures/#{file_name}"))
    end
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

