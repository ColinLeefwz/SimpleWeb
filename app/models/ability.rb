class Ability
  include CanCan::Ability

  def initialize(user, params)
    user ||= User.new

    if user.is_a? AdminUser
      can :manage, :all

    elsif user.is_a? Expert
      can :manage, Article do |article|
        article.try(:expert) == user
      end

      can :manage, Expert do |expert|
        expert == user
      end 
      cannot :delete, Expert
      cannot :create, Expert

      can [:show, :enroll, :enroll_confirm, :purchase, :sign_up_confirm], Course
      can :manage, Course do |course|
				course.experts.include?(user)
			end
      cannot :index, Course

    elsif user.is_a? Member
      can :read, Article 
      can :read, Expert
      can [:show, :enroll, :enroll_confirm, :purchase, :sign_up_confirm], Course
      can :manage, Member do |member|
        member == user
      end

      cannot :delete, Member
      cannot :refer_new_expert, Expert
    else
      can [:show, :enroll, :enroll_confirm, :purchase, :sign_up_confirm], Course
    end
  end
end
