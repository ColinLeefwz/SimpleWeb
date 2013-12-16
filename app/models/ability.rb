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

      can :manage, Course  #note: template solution

    elsif user.is_a? Member
      can :read, Session

      can :read, Expert

      can :manage, Course  #note: template solution

      can :manage, Member do |member|
        member == user
      end

      cannot :delete, Member
      cannot :refer_new_expert, Expert

    else
      can :read, Course
    end
  end
end
