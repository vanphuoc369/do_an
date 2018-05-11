module StaticPagesHelper

  def find_user_review user_id
    user = User.find_by id: user_id
    return user if user
  end

  def find_book_review book_id
    book = Book.find_by id: book_id
    return book if book
  end
end
