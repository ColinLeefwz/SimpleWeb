class UserFollowing
  attr_reader :message

  def initialize(user, target)
    @user = user
    @target = target
  end

  def toggle
    begin
      Following.follow?(@user, @target) ? destroy : create
    rescue Exception
      @message = "We are sorry, but something went wrong."
    end
  end


  private
  def create
    Following.create follower_id: @user.id, followed_id: @target.id
    @message = "You are now following #{@target.name}"
  end

  def destroy
    following = Following.find_by follower_id: @user.id, followed_id: @target.id
    following.destroy
    @message = "Unfollowed"
  end
end

