class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  has_many :comments, dependent: :destroy

  validates :content, presence: {accept: true, message: "không được để trống"}

  scope :newest, ->{order created_at: :desc}
end
