class UserBook < ApplicationRecord
  belongs_to :user
  belongs_to :book

  enum status: {no_mark: 0, reading: 1, read: 2}

  scope :count_likes, ->(book_id) do
    where("book_id = ? and is_favorite = ?", book_id, true) if book_id.present?
  end
end
