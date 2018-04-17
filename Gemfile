source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "bcrypt", "3.1.11"
gem "bootstrap-sass", "3.3.7"
gem "bootstrap-will_paginate", "1.0.0"
gem "carrierwave", "1.1.0"
gem "coffee-rails", "~> 4.2"
gem "config"
gem "faker", "1.7.3"
gem "fog-aws", "2.0.0"
gem "i18n-js"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "mini_magick", "4.7.0"
gem "minitest", ">=5.10.3"
gem "minitest-reporters", ">=1.1.19"
gem "mysql2", '~> 0.3.18'
gem "nokogiri", "1.8.1"
gem "puma", "~> 3.7"
gem "rails", "~> 5.1.4"
gem "rails-controller-testing"
gem "rubocop", "~> 0.51.0", require: false
gem "sass-rails", "~> 5.0"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"
gem "will_paginate", "3.1.6"
gem "blogit", github: "katanacode/blogit", branch: "master"
gem 'ckeditor', github: 'galetahub/ckeditor'
gem 'slim-rails', '3.1.1'

group :development, :test do
  gem 'sqlite3', '1.3.13'
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "capybara", "~> 2.13"
  gem "guard", "2.14.1"
  gem "guard-minitest", "2.4.6"
  gem "guard-rspec", "4.7.3"
  gem "selenium-webdriver"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :production do
  gem 'pg', '0.20.0'
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
