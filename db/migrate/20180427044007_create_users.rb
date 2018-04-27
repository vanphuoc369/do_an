class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email
      t.string :remember_digest
      t.string :password_digest
      t.string :activation_digest
      t.boolean :activated, default: false
      t.datetime :activated_at
      t.string :reset_digest
      t.boolean :is_admin, default: false
      t.datetime :reset_send_at

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
