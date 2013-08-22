set :views, Proc.new { File.join(root, 'app/views') }

get '/boards/:name' do |name|
  BoardsController.new(self).show name
end

get '/boards/:name/turn' do |name|
  BoardsController.new(self).turn name
end

get '/boards/:name/reset' do |name|
  BoardsController.new(self).reset name
end
