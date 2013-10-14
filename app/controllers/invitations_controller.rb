class InvitationsController < Devise::InvitationsController
  
 #before_filter :is_admin
 
 def create 
   self.resource = resource_class.invite!(invite_params, current_inviter)
   if resource.errors.empty?
     set_flash_message :notice, :send_instructions, :email => self.resource.email if self.resource.invitation_sent_at
     redirect_to admin_dashboard_url
   else
     respond_with_navigational(resource) { render :new }
   end
 end

 def edit 
   user = User.where(invitation_token: params[:invitation_token]).first
   user.type = 'Expert'
   user.save

   expert = Expert.where(invitation_token: params[:invitation_token]).first
   expert.create_profile
   super
 end
 
 def is_admin
   if !current_user.is_a?Member
     redirect_to admin_experts_url
   end
 end
end
