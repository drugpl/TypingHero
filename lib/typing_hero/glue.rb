require 'aquarium'

module TypingHero
  class Glue
    include Aquarium::Aspects

    def initialize(typing_hero, gui)
      @typing_hero = typing_hero
      @gui = gui
    end

    def apply
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
