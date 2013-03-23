require 'typing_hero/typing_hero'
require 'typing_hero/word'
require 'typing_hero/player'
require 'typing_hero/time_adapter'
require 'typing_hero/server/net_adapter'
require 'typing_hero/server/glue'

module TypingHero
  module Server
    class App

      WORDS = %w(hello world lorem ipsum dolor amet)

      def initialize(host = "localhost", port = 3100)
        typing_hero = TypingHero.new(WORDS.map { |word| Word.new(word) })
        time_adapter = TimeAdapter.new(1)
        net_adapter = NetAdapter.new(host, port)
        glue = Glue.new(typing_hero, time_adapter, net_adapter)

        glue.apply
        typing_hero.start
      end

    end
  end
end

Thread.abort_on_exception = true
