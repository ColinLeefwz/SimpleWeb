class UserFavorite
  attr_reader :message

  def initialize(user, target)
    @user = user
    @target = target
  end

  def toggle
    begin
      Subscription.favorited?(@user, @target) ? destroy : create
    rescue Exception
      @message = "We are sorry, but something went wrong."
    end
  end

  private
  def create
    Subscription.create subscribable: @target, subscriber_id: @user.id
    @message = "favorited"
  end

  def destroy
    favor = Subscription.find_by subscribable: @target, subscriber_id: @user.id
    favor.destroy
    @message = "un-favorited"
  end
end

