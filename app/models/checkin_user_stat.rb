class CheckinUserStat
  include Mongoid::Document
  field :l3, type: Array
  field :all, type: Integer
  field :cities, type: Array


  def user
    User.find_by_id(id)
  end

end

