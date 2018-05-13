class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :content, presence: {accept: true, message: "không được để trống."}

  scope :list_cmt, ->(review_id) do
    where('review_id = ? AND id_comment_reply IS ?', review_id, nil) if review_id.present?
  end

  scope :new_cmt, ->{order(created_at: :desc).limit(7)}

  scope :list_reply_cmt, ->(review_id, cmt_id) do
    where("review_id = ? AND id_comment_reply = ?", review_id, cmt_id) if (review_id.present? && cmt_id.present?)
  end

  scope :count_cmt_reply, ->(cmt_id) do
    where("id_comment_reply = '?' ", cmt_id) if cmt_id.present?
  end
end
