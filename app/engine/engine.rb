module Engine
  class Engine
    def self.instance(battle)
      @instances ||= {}
      @instances[battle.id] = self.new battle
    end

    def initialize(battle)
      @battle = battle
      @players = battle.robots.map { |r| Player.new r }
    end
    private :initialize

    def prepare_for_battle!
      if @underway
        puts "ERROR - This battle is already underway!"
        return false
      end

      @underway = true
      puts "Preparing for battle!"
      @players.each do |player|
        player.send :ready?
      end

      wait 30, by: 1
      ready? ? true : false
    end

    def turn
      alive_players.each do |player|
        player.send @battle.as_seen_by player.robot
      end

      wait 0.5, by: 0.01

      alive_players.each do |player|
        player.timeout unless player.ready?
      end

      alive_players.sort_by(&:priority).each do |player|
        player.turn!
      end

      alive_players.each do |player|
        player.handle_hits
        player.handle_power_ups
      end

      @battle.save!

      if @battle.game_over?
        @players.each do |player|
          player.sign_off
        end
        @underway = false
      end
    end

    private

    def alive_players
      @players.select { |p| p.alive? }
    end

    def ready?
      alive_players.all? { |p| p.ready? }
    end

    def wait(seconds, opts)
      now = Time.now
      sleep opts[:by] while Time.now - now < seconds && ! ready?
    end
  end
end
