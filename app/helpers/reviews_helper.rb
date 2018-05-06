module ReviewsHelper
  def find_user_review user_id
    user = User.find_by id: user_id
    return user if user
  end

  def review_update? review
    return true if review.created_at < review.updated_at
    false
  end

  def correct_user_review? review
    return true if review.user_id == current_user.id
    false
  end

  def load_star_rating rate
    result = []
    (1..5).each do |n|
      if n <= rate
        result << (content_tag :span, nil, class: "fa fa-star set_color")
      else
        result << load_star_empty(n - rate)
      end
    end
    safe_join result
  end

  def load_star_empty value
    if value == 0.5
      content_tag :span, nil, class: "fa fa-star-half-empty set_color"
    else
      content_tag :span, nil, class: "fa fa-star-o set_color"
    end
  end
end
