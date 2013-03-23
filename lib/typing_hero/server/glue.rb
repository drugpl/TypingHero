require 'aquarium'

module TypingHero
  module Server
    class Glue
      include Aquarium::Aspects

      def initialize(typing_hero, time_adapter, net_adapter)
        @typing_hero = typing_hero
        @time_adapter = time_adapter
        @net_adapter = net_adapter
        @players = []
      end

      def apply
        after(@typing_hero, :start) do
          @time_adapter.start
          @net_adapter.run
        end
        after(@typing_hero, [:time_unit_elapsed]) do
          @net_adapter.send_world(@typing_hero.visible_words, @players)
        end

        after(@time_adapter, :tick) { @typing_hero.time_unit_elapsed }

        after(@net_adapter, :word_received) { |_, _, word| @typing_hero.player_entered_word(@player, word) }
        after(@net_adapter, :client_connected) do
          puts "GOT CLIENT CONNECT"
          puts @players.inspect
          @players << Player.new("dupa")
          puts @players.inspect
        end
      end

      private
      def before(object, methods, &block)
        Aspect.new :before, methods: Array(methods), for_objects: [object] do |*args|
          block.call(args)
        end
      end

      def after(object, methods, &block)
        Aspect.new :after, methods: Array(methods), for_objects: [object] do |*args|
          block.call(args)
        end
      end

    end
  end
end
