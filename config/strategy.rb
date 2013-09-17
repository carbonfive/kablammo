# initialize strategy storage path
Strategy.strategies_location = File.join(ENV['KABLAMMO_STRATEGIES'] || settings.root, 'game_strategies')
Strategy.start_code_file_name = 'spawn.player.rb'
Strategy.start_code_file_location = File.join(settings.root, 'app', 'assets', 'process', Strategy.start_code_file_name)
