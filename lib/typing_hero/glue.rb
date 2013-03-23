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
      after(@typing_hero, :time_unit_elapsed) { @gui.update_words(@typing_hero.visible_words) }

      after(@time_adapter, :tick) { @typing_hero.time_unit_elapsed }
    end

    private
    def before(object, method, &block)
      Aspect.new :before, methods: [method], for_objects: [object] do |*args|
        block.call(args)
      end
    end

    def after(object, method, &block)
      Aspect.new :after, methods: [method], for_objects: [object] do |*args|
        block.call(args)
      end
    end

  end
end
