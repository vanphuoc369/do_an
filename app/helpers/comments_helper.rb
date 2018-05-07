module CommentsHelper

  def comment_update? comment
    comment.created_at < comment.updated_at ? true : false
  end

  def correct_user_comment? comment
    comment.user_id == current_user.id ? true : false if logged_in?
  end
end
