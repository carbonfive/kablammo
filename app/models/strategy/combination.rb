module Strategy
  class Combination < Base
    def initialize(&block)
      @chooser = block
    end

    def next_turn
      strategy = @chooser.call
      strategy.for_use_by self
      strategy.next_turn
    end
  end
end
