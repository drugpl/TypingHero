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
      after @typing_hero, :start do
        @time_adapter.start
      end
      after @typing_hero, :time_unit_elapsed do
        @gui.update_words(@typing_hero.visible_words)
      end

      after @time_adapter, :tick do
        @typing_hero.time_unit_elapsed
      end
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
