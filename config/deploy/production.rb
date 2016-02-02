server '54.165.254.9', user: 'deploy', roles: %w{app db web}
set :rails_env, "production"
set :branch, :production
