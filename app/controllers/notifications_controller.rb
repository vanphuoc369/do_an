class NotificationsController < ApplicationController
  before_action -> {check_login_or_save_url('/home_notifications')}, only: [:home]

  def index
    if params[:review_id]
      find_review_and_book params[:review_id]
    elsif params[:comment_id]
      find_comment params[:comment_id]
      if @comment
        if @comment.id_comment_reply
          find_comment_replied @comment.id_comment_reply
          @id_comment_reply = @comment.id_comment_reply
          @show_cmt_reply = true
        else
          @show_cmt = true
        end
        find_review @comment.review_id
        if @review
          find_book @review.book_id
          @user_book = UserBook.find_by(user_id: current_user.id, book_id: @book.id)
        end
      end
    elsif (params[:activity_id] && params[:notify_id])
      @activity = Activity.find_by id: params[:activity_id]
      if @activity.type_activity == "book"
        @book = Book.find_by id: @activity.object_id
        if @book
          @user_book = UserBook.find_by(user_id: current_user.id, book_id: @book.id)
          @review = (Review.find_by book_id: @book.id).first
        end
      elsif @activity.type_activity == "review"
        find_review_and_book @activity.object_id
      else
        find_comment @activity.object_id
        if @comment
          if @comment.id_comment_reply
            find_comment_replied @comment.id_comment_reply
            @id_comment_reply = @comment.id_comment_reply
            @show_cmt_reply = true
          else
            @show_cmt = true
          end
          find_review @comment.review_id
          if @review
            find_book @review.book_id
            @user_book = UserBook.find_by(user_id: current_user.id, book_id: @book.id)
          end
        end
      end
      @notify = Notification.find_by id: params[:notify_id]
      @notify.update_attributes is_see: true
    else
      flash[:danger] = "Thao tác không thành công."
      redirect_to root_path
    end
  end

  def home
    @all_notifications = Notification.all_notifications current_user.id
    @all_notifications = collection_paginate @all_notifications, params[:page], 9
    @favorite_books = Book.your_favorite_book current_user.id
    @mark_read_books = Book.your_mark_book current_user.id
  end

  private

  def notification_params
    params.permit :review_id, :comment_id, :activity_id, :notify_id
  end

  def find_review_and_book review_id
    @review = Review.find_by id: review_id
    if @review.nil?
      flash[:danger] = "Không tìm thấy bài đánh giá."
      redirect_to root_url
    else
      find_book @review.book_id
      @user_book = UserBook.find_by(user_id: current_user.id, book_id: @book.id)
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

  def find_comment comment_id
    @comment = Comment.find_by id: comment_id
    return if @comment
    flash[:danger] = "Không tìm thấy bình luận."
    redirect_to root_path
  end

  def find_comment_replied id_comment_reply
    @comment_replied = Comment.find_by id: id_comment_reply
    return if @comment_replied
    flash[:danger] = "Không tìm thấy bình luận."
    redirect_to root_url
  end
end
