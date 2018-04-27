namespace :admin do
  # desc "TODO"
  task admin_account: :environment do
    User.create!(full_name: "ADMIN", email: "admin@gmail.com", password: "123456",
      password_confirmation: "123456", is_admin: true, activated: true)
  end

end
