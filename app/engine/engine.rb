require 'benchmark'

module Engine
  class Engine
    def self.instance(battle)
      @instances ||= {}
      @instances[battle.id] = self.new battle
    end

    def initialize(battle)
      @battle = battle
      @players = battle.robots.map { |r| Player.new battle, r.username }
    end
    private :initialize

    def prepare_for_battle!
      if @underway
        puts "ERROR - This battle is already underway!"
        return false
      end

      @underway = true
      @count = 0
      puts "Preparing for battle!"
      @players.each do |player|
        player.send :ready?
      end

      wait 30, by: 1

      ready? ? true : false
    end

    def finish!
      @players.each do |player|
        player.sign_off
      end
    end

    def turn!
      #puts "======= TURN! ========="
      @count += 1
      players = turn = nil
      bm_dup = bm_send = bm_receive = bm_save = 0

      benchmark = Benchmark.measure do
        bm_dup = Benchmark.measure do
        #puts "pre: #{@battle.current_turn}"
        turn = @battle.current_turn.doppel
        @battle.turns << turn
        #puts "post: #{@battle.current_turn}"
        end

        players = alive_players

        bm_send = Benchmark.measure do
        players.each do |player|
          player.send @battle.as_seen_by(player.robot)
        end
        end

        bm_receive = Benchmark.measure do
        wait 0.5, by: 0.01
        end

        players.each do |player|
          player.timeout unless player.ready?
        end

        players.sort_by(&:priority).each do |player|
          player.turn!
        end

        players.each do |player|
          player.handle_power_ups
        end

        bm_save = Benchmark.measure do
        #puts "before save: #{@battle.current_turn}"
        @battle.current_turn.save!
        end
      end

      output players, [ benchmark, bm_dup, bm_send, bm_receive, bm_save ]

      if @battle.game_over?
        @players.each do |player|
          player.sign_off
        end
        @underway = false
        @count = 0
      end
      #puts "======= END ========="
    end

    private

    def f(tms)
      "%.2f" % tms.total
    end

    def output(players, benchmarks)
      turns = players.map.with_index do |player|
        value = "%4s" % player.handler.value
        "#{player.robot.username}: #{value}"
      end.join('  ')
      num = "%3s" % @count
      time = benchmarks.map { |b| f b }.join ' / '
      puts "#{num}: #{time} - #{turns}"
    end

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
