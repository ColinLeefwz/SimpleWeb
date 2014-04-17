ActiveAdmin.register Member do

  index do
    column :id
    column :name do |member|
      link_to member.name, admin_member_path(member)
    end
    column :user_name

    column :avatar do |member|
      link_to image_tag(member.avatar.url, width: "50"), admin_member_path(member)
    end

    column :email

    column "registration time" do |member|
      member.created_at.to_date
    end

    column :subscribe_newsletter

    column "social login?", :provider
    default_actions
  end

  form partial: "form"

  controller do
    defaults :finder => :find_by_user_name

    def scoped_collection
      Member.where(type: "Member")
    end

    def permitted_params
      params.permit :id, member: [:id, :name, :avatar, :first_name, :last_name, :user_name, :password, :email, :time_zone]
    end
  end

end
