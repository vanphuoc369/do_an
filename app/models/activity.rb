class Activity < ApplicationRecord
  belongs_to :user

  scope :your_activities, -> (user_id) do
    where("user_id = ?", user_id).order("created_at desc") if user_id.present?
  end
end
