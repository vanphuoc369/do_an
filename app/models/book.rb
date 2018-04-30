class Book < ApplicationRecord

  scope :alpha, ->{order updated_at: :desc}
  scope :search_books, ->(text) do
    where("author LIKE ? or title LIKE ?", "%#{text}%", "%#{text}%") if text.present?
  end
  scope :newest, ->{order(created_at: :desc).limit(4)}
end
