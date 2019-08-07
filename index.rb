if $0 =~ /^index.rb$/
  puts <<EOF
Usage: rackup -p <port>

Please run with rackup instead of 'ruby index.rb'.
Port is options.  Default port is 9292.

EOF
  exit 1
end

require 'pry'

require 'rubygems'
require 'bundler'
Bundler.require :default

require 'sinatra/base'
require 'sinatra/flash'
require 'sprockets'

class KablammoServer < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :bind, '0.0.0.0'

  # initialize new sprockets environment
  set :environment, Sprockets::Environment.new

  # append assets paths
  environment.append_path "app/assets"

  get "/assets/*" do
    env["PATH_INFO"].sub!("/assets", "")
    settings.environment.call(env)
  end

  enable :sessions

  register Sinatra::Flash
end

Dir['./ext/**/*.rb'].each { |file| require file }

Mongoid.load!("config/mongoid.yml")

require './app/models/target'
require './app/models/board' # need this before Battle

Dir['./app/models/**/*.rb'].each { |file| require file }

Dir['./app/controllers/*.rb'].each { |file| require file }

require './app/engine/turn_handler'
Dir['./app/engine/*.rb'].each { |file| require file }

require './config/strategy'
require './config/routes'
