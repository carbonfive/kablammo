require 'rubygems'
require 'bundler'
Bundler.require :default

require 'sinatra'
require 'json'

set :root, File.dirname(__FILE__)

require './config/mongo'

require './app/models/engine/turn_handler'
require './app/models/target'
require './app/models/board' # need this before Battle
Dir['./app/models/**/*.rb'].each   { |file| require file }
Dir['./app/controllers/*.rb'].each { |file| require file }

require './config/strategy'

register Sinatra::AssetPack

assets {
  serve '/js',     from: 'app/assets/js'
  serve '/css',    from: 'app/assets/css'
  serve '/images', from: 'app/assets/images'

  js :application, '/js/application.js', [
    '/js/vendor/**/*.js',
    '/js/app/ext.js',
    '/js/app/kablammo.js',
    '/js/app/battle.js',
    '/js/app/board.js',
    '/js/app/visualization.js'
    #'/js/app/kablammo.js',
    #'/js/app/**/*.js'
  ]

  css :application, '/js/application.css', [
    '/css/reset.css',
    '/css/**/*.css'
  ]
}

require './config/routes'
