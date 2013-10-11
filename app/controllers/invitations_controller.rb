class InvitationsController < Devise::InvitationsController
  
 #before_filter :is_admin
 
 def create 
   super
 end

 def edit 
   user = User.find_by_invitation_token(params[:invitation_token])
   user.type = 'Expert'
   user.save

   expert = Expert.where(invitation_token: params[:invitation_token]).first
   expert.create_profile
   super
 end

 def sent
 end
 
 def is_admin
   if !current_user.is_a?Member
     redirect_to admin_experts_url
   end
 end
end
