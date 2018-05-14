module Admin::ReviewsHelper
  def find_user_review review_id
    @review = Review.find_by id: review_id
    @user = User.find_by id: @review.user_id
    return @user if @user
  end

  def find_book_for_review review_id
    @review = Review.find_by id: review_id
    @book = Book.find_by id: @review.book_id
    return @book if @book
  end
end
