class CommentsController < ApplicationController
  load_and_authorize_resource except: [:create]

  def create
    respond_to do |format|
      format.js{ @comment = Comment.create comment_params }
    end
  end

  def destroy
    respond_to do |format|
      format.js{ current_user.delete(@comment) }
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:id, :user_id, :commentable_type, :commentable_id, :content)
  end
end
