module Admin
  class StaticPagesController < AdminController
    def index
      @count_users = User.all.count
      @count_books = Book.all.count
      @count_reviews = Review.all.count
      @count_comments = Comment.all.count
      @count_user_activated = User.users_activated.count
      @count_user_dont_activated = User.users_dont_activated.count
      @count_month_reviews_array = find_arr_month_reviews
    end

    private

    def find_arr_month_reviews
      @year = Time.current.year
      @result_array = Array.new
      @reviews = Review.find_reviews_in_year((1.year.ago(Time.current)), (Time.current))
      if @reviews.any?
        (1..12).each do |i|
          count = 0
          @reviews.each do |review|
            count += 1 if (review.created_at.month == i && review.created_at.year == @year)
          end
          @result_array << count
        end
      else
        (1..12).each do |i|
          @result_array << 0
        end
      end
      return @result_array
    end
  end
end
