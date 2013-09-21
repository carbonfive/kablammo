require 'mongo_mapper'

MongoMapper.connection = Mongo::Connection.new('localhost', :pool_size => 5, :pool_timeout => 5)
MongoMapper.database = 'kablammo_development'
