source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'rails-api', '~> 0.4.0'
gem 'active_model_serializers', '~> 0.10.0.rc3'
gem 'pg', '~> 0.18.3'
gem 'bcrypt', '~> 3.1.7'
gem 'rack-cors', '0.3.0'
gem 'devise_token_auth', '~> 0.1.36'
gem 'omniauth', "~> 1.2.2"
gem "paperclip", "4.2.1"
gem "rmagick", "2.14.0", require: false
gem 'geocoder', '~> 1.2', '>= 1.2.12'
gem "concord", "~> 0.1.5"

gem 'seedbank', '~> 0.3.0'
gem 'ffaker', '~> 2.1'
gem 'mailgun_rails', '~> 0.8.0'

gem 'state_machine', '~> 1.2'

group :development do
  gem "binding_of_caller", "0.7.1"
  gem "meta_request", "~> 0.3.4"
  gem "traceroute", "~> 0.4.0"
  gem "brakeman", "~> 2.6.3", require: false
  gem "letter_opener", "~> 1.3.0"

  # Deployment
  gem "mina", "~> 0.3.0"
  gem "mina-multistage", "~> 0.1.1", require: false
  gem "mina-scp", "~> 0.1.1"
  gem "java-properties", "~> 0.0.2"
end

group :production do
  gem "rails_12factor", "0.0.2"
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
