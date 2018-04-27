class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.references :user, foreign_key: true
      t.string :type_activity
      t.string :content
      t.integer :object_id

      t.timestamps
    end
  end
end
