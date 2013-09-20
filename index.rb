unless $0 =~ /rackup$/
  puts <<EOF
Usage: rackup -p <port>

Please run with rackup instead of 'ruby index.rb'.
Port is options.  Default port is 9292.
EOF
  exit 1
end

require 'rubygems'
require 'bundler'
Bundler.require :default

require 'sinatra/base'
require 'sinatra/flash'
require 'json'

class KablammoServer < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :bind, '0.0.0.0'

  enable :sessions

  register Sinatra::AssetPack
  register Sinatra::Flash

  assets {
    serve '/js',     from: 'app/assets/js'
    serve '/css',    from: 'app/assets/css'
    serve '/img',    from: 'app/assets/img'

    js :application, '/js/application.js', [
      '/js/vendor/jquery-2.0.3.js',
      '/js/vendor/*.js',
      '/js/app/ext.js',
      '/js/app/battle.js',
      '/js/app/board.js',
      '/js/app/visualization.js',
      '/js/app/main.js'
    ]

    css :application, '/css/application.css', [
      '/css/bootstrap.min.css',
      '/css/*.css'
    ]
  }
end

Dir['./ext/**/*.rb'].each { |file| require file }

require './config/mongo'

require './app/models/target'
require './app/models/board' # need this before Battle

Dir['./app/models/**/*.rb'].each { |file| require file }

Dir['./app/controllers/*.rb'].each { |file| require file }

require './app/engine/turn_handler'
Dir['./app/engine/*.rb'].each { |file| require file }

require './config/strategy'
require './config/routes'
