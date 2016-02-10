source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'rails-api', '~> 0.4.0'
gem 'active_model_serializers', '~> 0.10.0.rc4'
gem 'rails-i18n', '~> 4.0.0'
gem 'devise-i18n', '~> 0.12.1'
gem 'pg', '~> 0.18.3'
gem 'bcrypt', '~> 3.1.7'
gem 'rack-cors', '0.3.0'
gem 'devise_token_auth', '~> 0.1.37'
gem 'omniauth', "~> 1.2.2"
gem "paperclip", "4.2.1"
gem "rmagick", "2.14.0", require: false
gem 'geocoder', '~> 1.2', '>= 1.2.12'
gem "concord", "~> 0.1.5"

gem 'seedbank', '~> 0.3.0'
gem 'ffaker', '~> 2.1'
gem 'mailgun_rails', '~> 0.8.0'

gem 'state_machine', '~> 1.2'

gem 'time_difference', '~> 0.4.2'
gem 'apipie-rails', '~> 0.3.5'

gem 'kaminari', '~> 0.16.3'
gem 'pager_api', '~> 0.1.1'
gem 'actioncable', github: "rails/actioncable", branch: :archive

group :development do
  gem "binding_of_caller", "0.7.1"
  gem "meta_request", "~> 0.3.4"
  gem "traceroute", "~> 0.4.0"
  gem "brakeman", "~> 2.6.3", require: false
  gem "letter_opener", "~> 1.3.0"

  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
  gem 'capistrano3-puma'
end

group :production do
  gem 'puma'
end

group :test do
  gem 'rspec-its', '~> 1.2'
  gem "rspec-rails", "3.3.2"
  gem "factory_girl_rails", "4.4.0"
  gem "spork", "~> 1.0rc"
  gem "simplecov", "0.9.2", require: false
  gem "database_cleaner", "1.3.0"
  gem "shoulda-matchers", "2.8.0"
  gem "fivemat", "~> 1.3.1"
  gem 'test_after_commit', '~> 0.4.1'
end

group :development, :test do
  gem "pry", "0.9.12.6"
  gem "pry-rails", "0.3.2"
  gem "spring", "~> 1.3.6"
  gem "bullet", "4.14.6"
  gem "better_errors", "0.8.0"
  gem "annotate", "~> 2.6.8"
  gem "annotate_models", "~> 0.0.4"
  gem "rubocop", "~> 0.27.0", require: false
end
