class User < ActiveRecord::Base
  
  def safe_output
    self.attributes.slice("id", "name", "wb_uid", "gender", "birthday").merge!( {:logo => '/phone2/images/namei2.gif'} )
  end

end
