class CheckinUserStat
  include Mongoid::Document
  field :l3
  field :all


  def user
    User.find(id)
  end

end

