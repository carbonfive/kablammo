# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "kablammo"
set :repo_url, "git@github.com:carbonfive/kablammo.git"

set :branch, "chores/circleci"

set :user, "deploy"
set :deploy_to, "/home/deploy/apps/kablammo/"
set :use_sudo, false

set :bundle_flags, "--deployment --binstubs"

# linked_dirs persist across deploys. This will persist:
# - the bundle cache for faster deploys
# - pids, sockets, and logs for seamless deploys
# - game_strategies so they exist without re-downloading from github
append :linked_dirs, ".bundle", "tmp/pids", "tmp/sockets", "log", "game_strategies"

set :rbenv_ruby, File.read('.ruby-version').strip
