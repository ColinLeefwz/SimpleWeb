module CommentHelper
  def comment_counting(comments)
    count = comments.count
    count > 0 ? pluralize(comments.count, "Comment") : "Be the first to comment"
  end
end
