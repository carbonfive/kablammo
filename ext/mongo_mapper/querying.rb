if MongoMapper::Version < '0.13'
module MongoMapper
  module Plugins
    module Querying
      private
        def save_to_collection(options={})
          @_new = false
          collection.save(to_mongo, :w => options[:safe] ? 1 : 0)
        end
    end
  end
end
end
