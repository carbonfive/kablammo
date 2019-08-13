# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "kablammo"
set :repo_url, "git@github.com:carbonfive/kablammo.git"

set :branch, "chores/circleci"

set :user, "deploy"
set :deploy_to, "/home/deploy/apps/kablammo/"
set :use_sudo, false

set :bundle_flags, "--deployment --binstubs"

append :linked_dirs, ".bundle", "tmp/pids", "tmp/sockets", "log"

set :rbenv_ruby, File.read('.ruby-version').strip
