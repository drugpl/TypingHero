require 'forwardable'

module TypingHero
  class Word
    extend Forwardable

    attr_reader :content, :position

    def_delegators :position, :x, :x=, :y, :y=

    def initialize(content, position = Position.new(0,0))
      @content = content
      @position = position
    end

  end
end
