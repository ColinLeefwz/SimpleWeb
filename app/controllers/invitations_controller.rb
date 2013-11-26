require "mandrill_api"

class InvitationsController < Devise::InvitationsController

  #before_filter :is_admin

  def create
    if current_user.is_a? AdminUser
      admin_invite
    elsif current_user.is_a? Expert
      case params[:commit]
      when "Send"
        expert_invite 
      end
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

  def generated
  end

  def is_admin
    if !current_user.is_a?Member
      redirect_to admin_experts_url
    end
  end

  protected

  private
  def admin_invite
    self.resource = resource_class.invite!(invite_params, current_inviter) do |u|
      u.skip_invitation = true
    end

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions, :email => self.resource.email if self.resource.invitation_sent_at
      invitation_token = resource.invitation_token
			@invitation_link = "#{request.base_url}/users/invitation/accept?invitation_token=#{invitation_token}"
      render 'generated'
    else
      respond_with_navigational(resource) { render :new }
    end
  end

  def expert_invite
    @email_message = current_user.email_messages.create(set_email_message)

    self.resource = resource_class.invite!({ email: @email_message.to}, current_user) do |u|
      u.skip_invitation = true
    end

    @invitation_token = resource.invitation_token
    token_link = "#{request.base_url}/users/invitation/accept?invitation_token=#{@invitation_token}"

    mandrill = MandrillApi.new
    @candidate = Expert.where(email: params[:email_message][:to]).first 
    if @candidate.nil?
      mandrill.invite_by_expert(current_user, @email_message, token_link)
    end

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions, :email => self.resource.email if self.resource.invitation_sent_at
      redirect_to dashboard_expert_path(current_user)
    else
      respond_with_navigational(resource) { render :new }
    end
  end

  def set_email_message
    params.require(:email_message).permit(:subject, :to, :message, :copy_me, :from_name, :from_address, :to)
  end
end
