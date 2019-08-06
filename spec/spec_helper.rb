require 'rack/test'
require 'rspec'
require 'mongoid-rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../index.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  include Mongoid::Matchers
  def app() Sinatra::Application end
end

RSpec.configure do |c| 
  c.include RSpecMixin 
end
