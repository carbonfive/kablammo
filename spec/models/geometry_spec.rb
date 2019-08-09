require File.expand_path '../../spec_helper.rb', __FILE__

RSpec.describe Geometry, type: :model do
  Source = Struct.new(:x, :y)
  let(:subject) { Geometry.new(7, 7) }

  describe "#line_of_sight" do
    context "given a source in the middle of the map" do
      let(:source) { Source.new(3, 3) }

      it "should fire to the right" do
        degrees = 0
        los = subject.line_of_sight(source, degrees)

        expect(los).to eq([
          Pixel.new(4, 3),
          Pixel.new(5, 3),
          Pixel.new(6, 3)
        ])
      end

      it "should fire forward" do
        degrees = 90 
        los = subject.line_of_sight(source, degrees)

        expect(los).to eq([
          Pixel.new(3, 4),
          Pixel.new(3, 5),
          Pixel.new(3, 6)
        ])
      end

      it "should fire diagonally" do
        degrees = 45
        los = subject.line_of_sight(source, degrees)

        Pixel.new(4, 4).located_at?(source)

        expect(los).to eq([
          Pixel.new(4, 4),
          Pixel.new(5, 5),
          Pixel.new(6, 6)
        ])
      end
    end
  end
end