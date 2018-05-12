module ApplicationHelper
  def count_favorite book_id
    @count_favorite = Book.count_favorite(book_id).size
  end

  def book_star book
    if book.reviews.blank?
      @average = 0
      @count_rate = 0
    else
      @average = book.reviews.average(:rate).round 2
      @count_rate = book.reviews.count
    end
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

  def find_notifications
    if logged_in?
      @new_notifications = Notification.new_notifications @current_user.id
    end
  end
end
