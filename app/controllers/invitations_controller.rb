require "mandrill_api"

class InvitationsController < Devise::InvitationsController

  def create
    if current_user.is_a? AdminUser
      admin_invite
    else
      @email_message = current_user.email_messages.create(set_email_message)
      @email_message.update_attributes message: params[:email_message][:message]
      type = @email_message.invited_type
      case type
      when User::USER_TYPE[:expert]
        invite_expert
      when User::USER_TYPE[:member]
        invite_member
      end
    end
  end

  def edit
    user = User.where(invitation_token: params[:invitation_token]).first

    user_email = EmailMessage.find_by invite_token: params[:invitation_token]
    if user_email.present? # invited by Expert or Member
      invited_type = user_email.invited_type

      if invited_type == User::USER_TYPE[:expert]
        user.type = 'Expert'
        user.save
        expert = Expert.where(invitation_token: params[:invitation_token]).first
        expert.create_profile
      elsif invited_type == User::USER_TYPE[:member]
        user.type = 'Member'
        user.save
      end
    else ## invited by AdminUser
      user.type = "Expert"
      user.save
    end
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

  def invite_member
    invite_user "member"
  end

  def invite_expert
    invite_user "expert"
  end

  def invite_user(type)
    self.resource = resource_class.invite!({ email: @email_message.to}, current_user) do |u|
      u.skip_invitation = true
    end

    @invitation_token = resource.invitation_token
    token_link = "#{request.base_url}/users/invitation/accept?invitation_token=#{@invitation_token}"

    @email_message.update_attributes invite_token: @invitation_token

    mandrill = MandrillApi.new
    @candidate = Object.const_get(type.titleize).where(email: params[:email_message][:to]).first 
    if @candidate.nil?
      mandrill.send("invite_by_#{type}", current_user, @email_message, token_link)
    end

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions, :email => self.resource.email if self.resource.invitation_sent_at
      redirect_to (Rails.application.routes.url_helpers.send "dashboard_#{type}_path", current_user)
    else
      respond_with_navigational(resource) { render :new }
    end
  end

  def set_email_message
    params.require(:email_message).permit(:subject, :to, :message, :copy_me, :from_name, :from_address, :to, :invited_type)
  end
end
