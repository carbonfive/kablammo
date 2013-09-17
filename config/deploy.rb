require 'bundler/capistrano'
require 'puma/capistrano'

set :application, 'Kablammo'

set :scm,        :git
set :deploy_via, :copy
set :repository, 'git@github.com:carbonfive/kablammo.git'
set :branch,     'chores/deploy-to-production-56979742'

set :user,       'deploy'
set :deploy_to,  '/home/deploy/apps/kablammo/'
set :use_sudo,   false

set :bundle_flags, '--deployment --binstubs'

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

server 'kablammo.io', :app, :web, :db, primary: true


namespace :deploy do
  task :finalize_update do
  end
end

before 'bundle:install' do
  run "gem install bundler && rbenv rehash"
end

after 'deploy:finalize_update' do
  run "rbenv rehash"
end

after 'deploy:restart', 'deploy:cleanup'
