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

      can [:read, :enroll, :enroll_confirm, :purchase, :sign_up_confirm], Course
      can :manage, Course do |course|  #note: template solution
				course.experts.include?(user)
			end

    elsif user.is_a? Member
      can :read, Session

      can :read, Expert

      # can :read, Course  #note: template solution
      can [:read, :enroll, :enroll_confirm, :purchase, :sign_up_confirm], Course

      can :manage, Member do |member|
        member == user
      end

      cannot :delete, Member
      cannot :refer_new_expert, Expert

    else
      can :read, Course #note: guest should also be able to visit course enroll page
    end
  end
end
