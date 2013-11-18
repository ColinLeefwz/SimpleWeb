class Ability
  include CanCan::Ability

  def initialize(user, params)
    user ||= User.new

    if user.is_a? AdminUser
      can :manage, :all

    elsif user.is_a? Expert
      can :manage, Session do |session|
        session.try(:expert) == user
      end

      can :manage, Expert do |expert|
        expert == user
      end 

      cannot :delete, Expert
      cannot :create, Expert

    elsif user.is_a? Member

    else

    end
  end
end
