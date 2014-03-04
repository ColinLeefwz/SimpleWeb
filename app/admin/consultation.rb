ActiveAdmin.register Consultation do
  member_action :execute  do ##Peter at 03-04: can not use "process" here
    consultation = Consultation.find params[:id]
    consultation.update_attributes status: Consultation::STATUS[:processed]
    ##todo Peter at 03-04: will send email to the expert to notice
    redirect_to action: :show
  end

  index do
    column :requester
    column :consultant
    column :status
    column :description
    column :created_at
    column :updated_at

    #Peter at 03-04: show action links
    column "" do |resource|
      links = ''.html_safe
      links += link_to "show", resource_path(resource), :class => "member_link showlink"
      links += link_to "delete", resource_path(resource), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
      links += link_to "process", execute_admin_consultation_path(resource), :class => "member_link delete_link"
      links
    end
  end


end
