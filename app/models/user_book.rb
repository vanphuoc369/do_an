class UserBook < ApplicationRecord
  belongs_to :user
  belongs_to :book

  enum status: {no_mark: 0, reading: 1, read: 2}
end
