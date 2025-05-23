require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"

abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"

require "database_cleaner"
require "capybara/rspec"

Rails.root.glob("spec/support/**/*.rb").each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.fixture_paths = ["#{Rails.root}/spec/fixtures"]
  config.use_transactional_fixtures = true
  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
  config.before(:each) { DatabaseCleaner.strategy = :transaction }
  config.before(:each, :js) { DatabaseCleaner.strategy = :truncation }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  Shoulda::Matchers.configure do |conf|
    conf.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  config.before(:each) do
    @signed_in_user = create(:user)
    @signed_in_session = create(:session, user: @signed_in_user)
    @valid_token = JwtHelper.encode(@signed_in_session)
    @valid_headers = { "Authorization" => "Bearer #{@valid_token}", "User-Agent" => "Ruby/RSpec" }
    @invalid_headers = { "Authorization" => "Bearer bad_token" }
  end
end
