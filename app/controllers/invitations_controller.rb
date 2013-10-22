require "mandrill_api"

class InvitationsController < Devise::InvitationsController

 #before_filter :is_admin

 def create
   if current_user.is_a? AdminUser
     self.resource = resource_class.invite!(invite_params, current_inviter) do |u|
       u.skip_invitation = true
     end

     if resource.errors.empty?
       set_flash_message :notice, :send_instructions, :email => self.resource.email if self.resource.invitation_sent_at
       @invitation_token = resource.invitation_token
       render 'generated'
       #redirect_to admin_dashboard_url
     else
       respond_with_navigational(resource) { render :new }
     end
   elsif current_user.is_a? Expert
     @email_message = EmailMessage.create(set_email_message)

     invited_user_email = @email_message.to
     self.resource = resource_class.invite!({ email: invited_user_email}, current_user) do |u|
       u.skip_invitation = true
     end

     @invitation_token = resource.invitation_token
     token_link = "http://pdg.originatechina.com/users/invitation/accept?invitation_token=#{@invitation_token}"
     mandrill = MandrillApi.new
     send_result = mandrill.invite_by_expert(current_user, @email_message, token_link)
     logger.info "send invitation email result is : #{send_result}"

     if resource.errors.empty?
       set_flash_message :notice, :send_instructions, :email => self.resource.email if self.resource.invitation_sent_at
       redirect_to dashboard_expert_path(current_user)
       #redirect_to admin_dashboard_url
     else
       respond_with_navigational(resource) { render :new }
     end

   end
 end

 def edit
   user = User.where(invitation_token: params[:invitation_token]).first
   user.type = 'Expert'
   user.save

   expert = Expert.where(invitation_token: params[:invitation_token]).first
   expert.create_expert_profile
   super
 end

 def generated
 end

 def is_admin
   if !current_user.is_a?Member
     redirect_to admin_experts_url
   end
 end

 protected
 def set_email_message
   params.require(:email_message).permit(:subject, :to, :message, :copy_me)
 end
end
