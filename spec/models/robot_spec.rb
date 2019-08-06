require File.expand_path '../../spec_helper.rb', __FILE__

RSpec.describe Robot, type: :model do
  let!(:strategy) { Strategy.new(name: "strategy", username: "carbonfive") }

  before do
    allow(Strategy).to receive(:lookup).with("carbonfive").and_return(strategy)
  end

  it "refers to a strategy" do
    robot = Robot.new(username: "carbonfive")

    expect(robot.strategy).to eq(strategy)
  end

  it "is invalid by default" do
    robot = Robot.new(username: "carbonfive")
    expect(robot.valid?).to eq(false)
  end
end