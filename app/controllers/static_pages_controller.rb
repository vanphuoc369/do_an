class StaticPagesController < ApplicationController

  def home
    @new_books = Book.top4_newest
    @top_is_favorite_books = Book.top_is_favorite_book
    @top_read_books = Book.top_read_book
    @newest_review = Review.last
    @new_comments = Comment.new_cmt
  end

  def index
    if params[:request] == "1"
      @title_request = "Giới thiệu"
      @id = 1
    elsif params[:request] == "2"
      @title_request = "Quy định của website"
      @id = 2
    elsif params[:request] == "3"
      @title_request = "Hướng dẫn đăng nhập"
      @id = 3
    elsif params[:request] == "4"
      @title_request = "Hướng dẫn đăng ký"
      @id = 4
    elsif params[:request] == "5"
      @title_request = "Hướng dẫn kích hoạt tài khoản"
      @id = 5
    elsif params[:request] == "6"
      @title_request = "Hướng dẫn thiết lập mật khẩu"
      @id = 6
    end
  end

  private

  def notification_params
    params.permit :request
  end
end
