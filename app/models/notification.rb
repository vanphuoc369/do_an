class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  scope :new_notifications, -> (current_user_id) do
    where("user_id = ? AND is_see = false", current_user_id).order("created_at desc") if current_user_id.present?
  end

  scope :all_notifications, -> (current_user_id) do
    where("user_id = ?", current_user_id).order("created_at desc") if current_user_id.present?
  end
end
