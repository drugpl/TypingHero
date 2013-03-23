require 'forwardable'

module TypingHero
  class Word
    extend Forwardable

    attr_reader :content, :position

    def initialize(content, position = 0)
      @content = content
      @position = position
    end

    def increase_position
      @position += 0.01
    end

    def size
      @content.size
    end

  end
end
