require 'rubygems'
require 'bundler'
Bundler.require :default

require 'sinatra'
require 'json'

require './config/mongo'
require './app/models/engine/turn'
Dir['./app/models/**/*.rb'].each   { |file| require file }
Dir['./app/controllers/*.rb'].each { |file| require file }

set :root, File.dirname(__FILE__)

register Sinatra::AssetPack

assets {
  serve '/js',  from: 'app/assets/js'
  serve '/css', from: 'app/assets/css'

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
