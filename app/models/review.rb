class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  has_many :comments, dependent: :destroy

  validates :content, presence: {accept: true, message: "không được để trống"}

  scope :newest, ->{order created_at: :desc}

  scope :find_reviews_to_report, ->(book_id, user_id) do
    where("book_id = ? AND user_id != ?", book_id, user_id) if (book_id.present? && user_id.present?)
  end
end
