server '52.33.86.87', user: 'deploy', roles: %w{app db web}
set :rails_env, "production"
set :branch, :master
