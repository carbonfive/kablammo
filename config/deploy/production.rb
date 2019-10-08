server "kablammo.io", user: "deploy", roles: %w{app db web}, primary: true

set :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
