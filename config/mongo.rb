require 'mongo_mapper'

MongoMapper.connection = Mongo::Connection.new 'localhost'
MongoMapper.database = 'kablammo_development'
