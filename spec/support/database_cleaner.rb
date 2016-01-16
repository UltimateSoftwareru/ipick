require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner[:active_record, {:connection => "iwant_users_#{Rails.env}".to_sym}].strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    DatabaseCleaner[:active_record, {:connection => "iwant_users_#{Rails.env}".to_sym}].start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    DatabaseCleaner[:active_record, {:connection => "iwant_users_#{Rails.env}".to_sym}].clean
  end
end
