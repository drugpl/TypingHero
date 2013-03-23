require 'aquarium'

module TypingHero
  class Glue
    include Aquarium::Aspects

    def initialize(typing_hero, gui, time_adapter)
      @typing_hero = typing_hero
      @gui = gui
      @time_adapter = time_adapter
    end

    def apply
      after(@typing_hero, :start) { @time_adapter.start }
      after(@typing_hero, [:time_unit_elapsed, :player_correctly_typed_word]) do
        @gui.update_words(@typing_hero.visible_words)
      end

      after(@time_adapter, :tick) { @typing_hero.time_unit_elapsed }

      after(@gui, :word_entered) { @typing_hero.player_entered_word }
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
