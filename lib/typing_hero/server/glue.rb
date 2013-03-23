require 'aquarium'

module TypingHero
  module Server
    class Glue
      include Aquarium::Aspects

      def initialize(typing_hero, time_adapter, net_adapter)
        @typing_hero = typing_hero
        @time_adapter = time_adapter
        @net_adapter = net_adapter
        @players_handlers = {}
      end

      def apply
        after(@typing_hero, :start) do
          @time_adapter.start
          @net_adapter.run
        end
        after(@typing_hero, [:time_unit_elapsed, :new_player_joined, :player_correctly_entered_word]) do
          @net_adapter.send_world(@typing_hero.visible_words, @typing_hero.players)
        end

        after(@typing_hero, :player_correctly_entered_word) do |_, _, player, word|
          get_client(player).inform_about_correct_word(word)
        end
        after(@typing_hero, :player_incorrectly_entered_word) do |_, _, player|
          get_client(player).inform_about_incorrect_word
        end

        after(@time_adapter, :tick) { @typing_hero.time_unit_elapsed }

        after(@net_adapter, :word_received) do |_, _, client, word|
          @typing_hero.player_entered_word(get_player(client), word)
        end
        after(@net_adapter, :client_connected) do |_, _, name, handler|
          @typing_hero.new_player_joined(name)
          @players_handlers[@typing_hero.last_player] = handler
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

      def get_player(client)
        @players_handlers.invert[client]
      end

      def get_client(player)
        @players_handlers[player]
      end

    end
  end
end
