module TypingHero
  class Position < Struct.new(:x, :y)
    def initialize(x = 0, y = 0)
      super
    end
  end

end
