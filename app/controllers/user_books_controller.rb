class UserBooksController < ApplicationController
  before_action :find_book
  before_action -> {check_login_or_save_url(book_path @book.id)}

  def create
    if params[:button] == "like"
      @user_book= UserBook.new(user_id: current_user.id, book_id: @book.id, is_favorite: true)
      Activity.create(user_id: current_user.id, type_activity: "book", content: "Bạn đã đánh dấu yêu thích sách", object_id: @book.id)
      @notify_mark = "Đánh dấu sách ưa thích thành công."
    elsif params[:button] == "read"
      @user_book= UserBook.new(user_id: current_user.id, book_id: @book.id, status: 2)
      Activity.create(user_id: current_user.id, type_activity: "book", content: "Bạn đã đánh dấu đã đọc sách", object_id: @book.id)
      @notify_mark = "Đánh dấu sách đã đọc thành công."
    else
      @user_book= UserBook.new(user_id: current_user.id, book_id: @book.id, status: 1)
      Activity.create(user_id: current_user.id, type_activity: "book", content: "Bạn đã đánh dấu đang đọc sách", object_id: @book.id)
      @notify_mark = "Đánh dấu sách đang đọc thành công."
    end
    if @user_book.save
      respond_to do |format|
        format.html {redirect_to @user_book, @book}
        format.js
      end
    else
      flash[:danger] = "Đánh dấu sách thất bại."
      redirect_to book_path(params[:book_id])
    end
  end

    def update
    @user_book = UserBook.find_by id: params[:id]
    is_favorite = params[:is_favorite]
    status = params[:status]
    if params[:button] == "like"
      is_favorite = mark_like is_favorite
    else
      status = mark_read status, params[:button]
    end
    if @user_book.update_attribute(:is_favorite, is_favorite) && @user_book.update_attribute(:status, status)
      if is_favorite == params[:is_favorite]
        if status == :read
          Activity.create(user_id: current_user.id, type_activity: "book", content: "Bạn đã đánh dấu đã đọc sách", object_id: @book.id)
          @notify_mark = "Đánh dấu sách đã đọc thành công."
        elsif status == :reading
          Activity.create(user_id: current_user.id, type_activity: "book", content: "Bạn đã đánh dấu đang đọc sách", object_id: @book.id)
          @notify_mark = "Đánh dấu sách đang đọc thành công."
        else
          Activity.create(user_id: current_user.id, type_activity: "book", content: "Bạn đã hủy đánh dấu sách", object_id: @book.id)
          @notify_mark = "Hủy đánh dấu sách thành công."
        end
      else
        if is_favorite == true
          Activity.create(user_id: current_user.id, type_activity: "book", content: "Bạn đã đánh dấu yêu thích sách", object_id: @book.id)
          @notify_mark = "Đánh dấu sách ưa thích thành công."
        else
          Activity.create(user_id: current_user.id, type_activity: "book", content: "Bạn đã hủy đánh dấu yêu thích sách", object_id: @book.id)
          @notify_mark = "Hủy đánh dấu sách ưa thích thành công."
        end
      end
      respond_to do |format|
        format.html {redirect_to @user_book, @book}
        format.js
      end
    else
      flash[:danger] = "Đánh dấu sách thất bại."
      redirect_to book_path(params[:book_id])
    end
  end

  private

  def find_book
    @book = Book.find_by id: params[:book_id]
    return if @book
    flash[:danger] = "Không tìm thấy sách"
    redirect_to root_path
  end

  def mark_like value_params
    value_params == "false"
  end

  def mark_read value_params_status, value_params_button
    if value_params_button == "read"
      value_params_status != "read" ? :read : :no_mark
    else
      value_params_status != "reading" ? :reading : :no_mark
    end
  end

  def active_favorite_book favorite
    if favorite == false
      return (t ".unlike_book", book: @book.title), "favorite"
    else
      return (t ".like_book", book: @book.title), "unfavorite"
    end
  end

  def new_value_content_and_type_activity
    if params[:button] == "like"
      return (t ".like_book", book: @book.title), "favorite"
    elsif params[:button] == "read"
      return (t ".read_book", book: @book.title), "read"
    else
      return (t ".reading_book", book: @book.title), "reading"
    end
  end
end
