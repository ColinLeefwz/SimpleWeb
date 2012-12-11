class Baidu
  include Mongoid::Document
  store_in({:collection =>  "baidu", :session => "dooo"})
end
