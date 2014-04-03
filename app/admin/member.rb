ActiveAdmin.register Member do

  index do
    column :name do |member| 
      link_to member.name, admin_member_path(member)
    end

    column :avatar do |member|
      link_to image_tag(member.avatar.url, width: "50"), admin_member_path(member)
    end

    column :email

    column "registration time" do |member|
      member.created_at.to_date
    end

    column :subscribe_newsletter

    column "social login?", :provider
  end

  controller do
    def scoped_collection
      Member.where(type: "Member")
    end
  end

end
