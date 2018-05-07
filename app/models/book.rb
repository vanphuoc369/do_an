class Book < ApplicationRecord
  has_many :user_books, dependent: :destroy
  has_many :users, through: :user_books
  has_many :reviews, dependent: :destroy

  scope :alpha, ->{order updated_at: :desc}
  scope :search_books, ->(text) do
    where("author LIKE ? or title LIKE ?", "%#{text}%", "%#{text}%") if text.present?
  end
  scope :top4_newest, ->{order(created_at: :desc).limit(4)}

  scope :top_is_favorite_book, -> do
    joins(:user_books).where("is_favorite = true").group("books.id").order("count(is_favorite) desc").limit(4)
  end

  scope :top_read_book, -> do
    joins(:user_books).where("status != 0").group("books.id").order("count(status) desc").limit(5)
  end

  scope :count_favorite, -> (book_id) do
    joins(:user_books).where("is_favorite = true AND book_id = #{book_id}").select("count(books.id)")
  end
end
