class NewYearWish
  include Mongoid::Document
  field :_id,  type: Moped::BSON::ObjectId
  field :total, type: Integer
  field :data, type: Array
  field :template, type: Integer

  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :user, :desc, :to => :photo
  end

  def photo
    Photo.find_by_id(_id)
  end

  def user_logo
    user = self.photo_user
    return '' if user.nil?
    logo = user.head_logo
    return '' if logo.nil?
    logo.img.url(:t2)
  end
  
  def people
    return '梦露' unless self.template
    ['梦露', '金正恩', '习主席', '赫本', '奥巴马'].at(self.template)
  end
  
end