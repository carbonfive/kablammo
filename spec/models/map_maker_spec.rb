require File.expand_path '../../spec_helper.rb', __FILE__

RSpec.describe MapMaker, type: :model do
  context "given a simple map" do
    let(:map) do
      MapMaker.make("simple", [
        "_x_",
        "__2",
        "1__",
      ],{
        1 => 0,
        2 => 180,
      })
    end

    it "creates a wall" do
      expect(map.walls.length).to be(1)
      expect(map.walls[0].x).to be(1)
      expect(map.walls[0].y).to be(2)
    end

    it "creates a robot start" do
      expect(map.starts.length).to be(2)

      expect(map.starts[0]).to eq([0, 0, 0])
      expect(map.starts[1]).to eq([2, 1, 180])
    end
  end
end