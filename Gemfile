source "https://rubygems.org"

gem "bootsnap", require: false # Reduces boot times through caching; required in config/boot.rb
gem "kamal", require: false
gem "pg"
gem "puma", ">= 5.0"
gem "rack-cors"
gem "rails", "~> 8.0.2"
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"
gem "sqlite3", ">= 2.1"
gem "thruster", require: false # Add HTTP asset caching/compression and X-Sendfile acceleration to Puma
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "brakeman", require: false
  gem "capybara"
  gem "database_cleaner"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails"
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "fasterer"
  gem "overcommit"
  gem "rubocop"
  gem "rubocop-config-prettier"
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "rubocop-rspec"
end

group :test do
  gem "shoulda-matchers"
  gem "simplecov"
end
