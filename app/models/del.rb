class Del
  include Mongoid::Document
  field :name
  field :data, type:Array
end
