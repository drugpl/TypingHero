module TypingHero
  class Player

    attr_reader :name, :score

    def initialize(name = "Anonymous", score = 0)
      @name = name
      @score = score
    end

    def add_points(points)
      @score += points
    end

  end
end
