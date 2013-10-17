class Ability
  include CanCan::Ability

  def initialize(user, params)
    user ||= User.new

    if user.is_a? AdminUser
      can :manage, :all

    elsif user.is_a? Expert
      can :create, Session
      can :update, Session do |session|
        session.try(:expert) == user
      end
      can :manage, :dashboard do
        user.id.to_s == params[:id]
      end
    elsif user.is_a? Member

    end
  end
end
