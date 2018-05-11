class NotificationsController < ApplicationController

  def index
    if params[:review_id]
      find_review_and_book
    elsif params[:comment_id]
      find_comment
      if @comment.id_comment_reply
        find_comment_replied @comment.id_comment_reply
        @show_cmt_reply = true
      else
        @show_cmt = true
      end
      find_review @comment.review_id
      find_book @review.book_id
    else
      flash[:danger] = "Thao tác không thành công."
      redirect_to root_path
    end
  end

  private

  def notification_params
    params.permit :review_id, :comment_id
  end

  def find_review_and_book
    @review = Review.find_by id: params[:review_id]
    if @review.nil?
      flash[:danger] = "Không tìm thấy bài đánh giá."
      redirect_to root_url
    else
      find_book @review.book_id
    end
  end

  def find_book book_id
    @book = Book.find_by id: book_id
    return if @book
    flash[:danger] = "Không tìm thấy sách."
    redirect_to root_path
  end

  def find_review review_id
    @review = Review.find_by id: review_id
    return if @review
    flash[:danger] = "Không tìm bài đánh giá."
    redirect_to root_path
  end

  def find_comment
    @comment = Comment.find_by id: params[:comment_id]
    return if @comment
    flash[:danger] = "Không tìm thấy bình luận."
    redirect_to root_url
  end

  def find_comment_replied id_comment_reply
    @comment_replied = Comment.find_by id: id_comment_reply
    return if @comment_replied
    flash[:danger] = "Không tìm thấy bình luận."
    redirect_to root_url
  end
end
