set :views, Proc.new { File.join(root, 'app/views') }

get '/battles/new' do
  BattlesController.new(self).create
end

get '/battles/:id' do |id|
  BattlesController.new(self).show id
end

post '/battles/:id/turn.json' do |id|
  BattlesController.new(self).turn id
end
