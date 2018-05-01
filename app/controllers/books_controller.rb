class BooksController < ApplicationController
  before_action :find_book, only: :show

  def index
    if params[:search].blank?
      load_books
    else
      search_title_and_author
    end
  end

  def book_params
    params.permit :search
  end

  def show
    find_book_mark(params[:id], current_user.id) if logged_in?
  end

  private

  def find_book
    @book = Book.find_by id: params[:id]
    return if @book
    flash[:danger] = "Không tìm thấy sách"
    redirect_to root_path
  end

  def search_title_and_author
    @books = Book.search_books params[:search]
    @books = collection_paginate @books, params[:page], 5
    @title_index = "Kết quả tìm kiếm cho " + "'#{params[:search]}'"
  end

  def find_book_mark book_id, user_id
    @user_book = UserBook.find_by book_id: book_id, user_id: user_id
    @notify_user_book = "Bạn chưa đánh dấu sách" if @user_book.nil?
  end

  def load_books
    @books = Book.alpha
    @books = collection_paginate @books, params[:page], 5
    @title_index = "Tất cả sách"
  end
end
