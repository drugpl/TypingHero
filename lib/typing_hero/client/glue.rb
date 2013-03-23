require 'aquarium'

module TypingHero
  module Client
    class Glue
      include Aquarium::Aspects

      def initialize(net_adapter, gui, player)
        @net_adapter = net_adapter
        @gui = gui
        @player = player
      end

      def apply
        after(@net_adapter, :message_received) do |_, _, message|
          @gui.update_words(message[:words])
          @gui.update_scores(message[:players])
          @gui.update_score(message[:players][@player.name].score)
        end

        after(@gui, :word_entered) do |_, _, word|
          @net_adapter.send_message({word: word})
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