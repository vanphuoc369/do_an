class ReviewsController < ApplicationController
  before_action :logged_in_user, except: :show
  before_action :find_book
  before_action :check_review, only: :new
  before_action :find_review, except: %i(new create)

  def new
    @review = @book.reviews.build
  end

  def show
    find_comments @review
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @review = current_user.reviews.build review_params
    if @book.reviews << @review
      @activity = Activity.create(user_id: current_user.id, type_activity: "review", content: "Bạn đã đánh giá sách", object_id: @review.id)
      @reviews = Review.find_reviews_to_report(@review.book_id, current_user.id)
      if @reviews
        @reviews.each do |review|
          user = User.find_by id: review.user_id
          if user
            Notification.create(user_id: user.id, activity_id: @activity.id,
              content: current_user.full_name + " đã thêm đánh giá cho sách mà bạn đã tham gia đánh giá.")
          end
        end
      end
      flash[:success] = "Đăng bài thành công"
      redirect_to @book
    else
      render :new
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    if @review.update_attributes review_params
      Activity.create(user_id: current_user.id, type_activity: "review", content: "Bạn đã cập nhật bài đánh giá sách", object_id: @review.id)
      flash[:success] = "Cập nhập bài đánh giá thành công!"
    else
      flash[:danger] = "Cập nhập bài đánh giá không thành công! Vui lòng kiểm tra lại nội dung bài đánh giá."
    end
    redirect_to @book
  end

  def destroy
    if @review.destroy
      Activity.create(user_id: current_user.id, type_activity: "book", content: "Bạn đã xóa bài đánh giá sách", object_id: @book.id)
      flash[:success] = "Xóa bài đánh giá thành công!"
    else
      flash[:danger] = "Xóa bài đánh giá không thành công."
    end
    redirect_to @book
  end

  private

  def find_book
    @book = Book.find_by id: params[:book_id]
    return if @book
    flash[:danger] = "Không tìm thấy sách."
    redirect_to root_path
  end

  def reviewed user_id, book_id
    review = Review.find_by user_id: user_id, book_id: book_id
    return unless review
    flash[:danger] = "Bạn đã đánh giá cho quyển sách này. Bạn chỉ có thể cập nhật lại đánh giá."
    redirect_to @book
  end

  def check_review
    reviewed current_user.id, params[:book_id]
  end

  def review_params
    params.require(:review).permit :content, :rate, :book_id
  end

  def find_review
    @review = Review.find_by id: params[:id]
    redirect_to root_url if @review.nil?
  end

  def find_comments review
    @comments = Comment.list_cmt(review.id.to_s)
    return @notify_comment_empty = "Chưa có bình luận cho bài đánh giá." if @comments.empty?
  end
end
