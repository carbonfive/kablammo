require File.expand_path '../../spec_helper.rb', __FILE__

RSpec.describe Battle, type: :model do
  let(:map) { Map.for_name("KISS") }
  let(:robot_alice) { Robot.new(username: "alice") }
  let(:robot_bob) { Robot.new(username: "bob") }
  let(:robots) { [robot_alice, robot_bob] }
  let(:battle) { Battle.wage(map, robots) }

  describe "#wage" do
    it "should create a first turn" do
      expect(battle.turns.count()).to eq(1)
    end

    it "takes a turn" do
      turn = battle.current_turn.doppel

      battle.turns << turn

      battle.save!
      expect(battle.turns.count()).to eq(2)

      # Make sure the turns persist
      saved_battle = Battle.find(battle.id)
      expect(saved_battle.turns.count()).to eq(2)
    end
  end
end