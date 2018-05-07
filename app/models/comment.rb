class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :content, presence: {accept: true, message: "không được để trống."}
end
