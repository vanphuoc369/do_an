module Admin
  class BooksController < AdminController
    before_action :find_book, except: %i(index new create)

    def index
      @books = Book.new_book.paginate page: params[:page], per_page: 5
    end

    def new
      @book = Book.new
    end

    def create
      @book = Book.new book_params
      if @book.save
        flash[:success] = "Them sach thanh cong"
        redirect_to admin_books_path
      else
        render :new
      end
    end

    def edit; end

    def update
      if @book.update_attributes book_params
        flash[:sucess] = "Cap nhat thanh cong"
        redirect_to admin_books_path
      else
        render :edit
      end
    end

    def destroy
      if @book.destroy
        flash[:success] = "Xoa thanh cong"
      else
        flash[:danger] = "Xoa khong thanh cong"
      end
      redirect_to admin_books_path
    end

    private

    def book_params
      params.require(:book).permit :title, :author, :image, :publish_date, :number_of_pages, :summary
    end

    def find_book
      debugger
      @book = Book.find_by id: params[:id]
      return if @book
      flash[:danger] = "Khong tim thay sach"
      redirect_to admin_books_path
    end
  end
end
