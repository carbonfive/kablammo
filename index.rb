require 'rubygems'
require 'bundler'
Bundler.require :default

require 'sinatra'
require 'json'

require './config/mongo'

module Engine end
module Strategy end
require './app/models/engine/turn_handler'
require './app/models/strategy/base'
Dir['./app/models/**/*.rb'].each   { |file| require file }
Dir['./app/controllers/*.rb'].each { |file| require file }

set :root, File.dirname(__FILE__)

register Sinatra::AssetPack

assets {
  serve '/js',     from: 'app/assets/js'
  serve '/css',    from: 'app/assets/css'
  serve '/images', from: 'app/assets/images'

  js :application, '/js/application.js', [
    '/js/vendor/**/*.js',
    '/js/app/kablammo.js',
    '/js/app/**/*.js'
  ]

  css :application, '/js/application.css', [
    '/css/reset.css',
    '/css/**/*.css'
  ]
}

require './config/routes'
