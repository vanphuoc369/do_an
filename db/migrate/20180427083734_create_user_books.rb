class CreateUserBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :user_books do |t|
      t.references :user, foreign_key: true
      t.references :book, foreign_key: true
      t.boolean :is_favorite
      t.integer :status,  default: 0

      t.timestamps
    end
  end
end
