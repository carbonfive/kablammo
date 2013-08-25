require 'sinatra'
require 'json'

require './config/mongo'

require './app/models/engine/turn'
Dir['./app/models/**/*.rb'].each   { |file| require file }
Dir['./app/controllers/*.rb'].each { |file| require file }

require './config/routes'
