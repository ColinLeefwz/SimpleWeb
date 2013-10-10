class InvitationsController < Devise::InvitationsController
  
 #before_filter :is_admin
 def create 
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
