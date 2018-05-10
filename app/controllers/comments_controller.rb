class CommentsController < ApplicationController

  before_action :find_review
  before_action :find_book, only: [:create, :update, :destroy]
  before_action :find_comment, only: %i(destroy edit update)
  before_action -> {check_login_or_save_url(book_review_path params[:book_id], params[:review_id])}

  def new; end

  def create
    @comment = current_user.comments.build comment_params
    if @comment.content.empty?
      flash.now[:warning] = "Hãy viết suy nghĩ của bạn vào phần nội dung bình luận."
    elsif @review.comments << @comment
      flash.now[:success] = "Đăng bình luận thành công!"
    else
      flash.now[:danger] = "Đăng bình luận thất bại."
    end
    find_comments params[:review_id]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    if params[:commit] != 'Hủy bỏ'
      if @comment.update comment_params
        flash.now[:success] = "Chỉnh sửa bình luận thành công!"
      else
        flash.now[:danger] = "Chỉnh sửa bình luận thất bại, vui lòng kiểm tra lại!"
      end
    end
    find_comments params[:review_id]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @book = Book.find_by id: params[:book_id]
    if @comment
      respond_to do |format|
        format.html {redirect_to @book, @review, @comment}
        format.js
      end
    else
      flash[:danger] = "Bình luận không được tìm thấy."
      redirect_to book_path(params[:book_id])
    end
  end

  def destroy
    if @comment.destroy
      flash.now[:success] = "Xóa bình luận thành công!"
    else
      flash.now[:danger] = "Xóa bình luận thất bại!"
    end
    find_comments params[:review_id]
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit :review_id, :content
  end

  def find_review
    @review = Review.find_by id: params[:review_id]
    if @review.nil?
      flash[:danger] = "Không tìm thấy bài đánh giá."
      redirect_to book_path(params[:book_id])
    end
  end

  def find_comment
    @comment = Comment.find_by id: params[:id]
    redirect_to root_url if @comment.nil?
  end

  def find_comments review_id
    find_review
    @comments = @review.comments
    return @notify_comment_empty = "Chưa có bình luận cho bài đánh giá." if @comments.empty?
  end
  def find_book
    @book = Book.find_by id: params[:book_id]
  end
end
