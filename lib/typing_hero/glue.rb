require 'aquarium'

module TypingHero
  class Glue
    include Aquarium::Aspects

    def initialize(typing_hero, gui, time_adapter, net_adapter, player)
      @typing_hero = typing_hero
      @gui = gui
      @time_adapter = time_adapter
      @net_adapter = net_adapter
      @player = player
    end

    def apply
      after(@typing_hero, :start) { @time_adapter.start }
      after(@typing_hero, :time_unit_elapsed) do
        @gui.update_words(@typing_hero.visible_words)
      end
      after(@typing_hero, :player_correctly_entered_word) do |_, _, player, word|
        @gui.update_words(@typing_hero.visible_words)
        @gui.word_correct(word)
        @gui.update_score(player.score)
      end

      after(@time_adapter, :tick) { @typing_hero.time_unit_elapsed }

      after(@net_adapter, :word_received) { |_, _, word| @typing_hero.player_entered_word(@player, word) }

      after(@gui, :word_entered) { |_, _, word| @typing_hero.player_entered_word(@player, word) }
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
