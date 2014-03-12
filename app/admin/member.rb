ActiveAdmin.register Member do

  index do
    column :name do |member| 
      link_to member.name, admin_member_path(member)
    end

    column :avatar do |member|
      link_to image_tag(member.avatar.url, width: "50"), admin_member_path(member)
    end

    column :email

    column "social login?", :provider
  end

  controller do
    def scoped_collection
      Member.where(type: "Member")
    end
  end

end