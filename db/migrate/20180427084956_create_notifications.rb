class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :activity, foreign_key: true
      t.boolean :is_see, default: false
      t.string :content

      t.timestamps
    end
  end
end
