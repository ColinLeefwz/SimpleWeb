class Category < ActiveRecord::Base
  default_scope { order('name') }
end
