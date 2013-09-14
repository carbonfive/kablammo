require 'rubygems'
require 'bundler'
Bundler.require :default

require 'sinatra/base'
require 'json'

class KablammoServer < Sinatra::Base
  set :root, File.dirname(__FILE__)

  register Sinatra::AssetPack
  assets {
    serve '/js',     from: 'app/assets/js'
    serve '/css',    from: 'app/assets/css'
    serve '/img', from: 'app/assets/img'

    js :application, '/js/application.js', [
      '/js/vendor/**/*.js',
      '/js/app/ext.js',
      '/js/app/battle.js',
      '/js/app/board.js',
      '/js/app/visualization.js'
    ]

    css :application, '/css/application.css', [
      '/css/bootstrap.min.css',
      '/css/**/*.css'
    ]
  }
end

require './config/mongo'

require './app/models/target'
require './app/models/board' # need this before Battle
Dir['./app/models/**/*.rb'].each { |file| require file }

Dir['./app/controllers/*.rb'].each { |file| require file }

require './app/engine/turn_handler'
Dir['./app/engine/*.rb'].each { |file| require file }

require './config/strategy'
require './config/routes'
