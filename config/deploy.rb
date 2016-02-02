set :application, 'ipick'
set :repo_url, 'git@bitbucket.org:iwantinc/ipick.git'
set :branch, 'master'
set :deploy_to, '/home/deploy/applications/ipick'

set :user, "deploy"
set :use_sudo, true

set :log_level, :info
set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

set :rbenv_type, :user
set :rbenv_ruby, '2.2.3'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_roles, :all

set :puma_init_active_record, true
