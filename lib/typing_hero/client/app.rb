module TypingHero
  module Client
    class App
      def initialize(host = 'localhost', port = 3100)
        gui = CursesGui.new
        player = Player.new("john")
        net_adapter = NetAdapter.new(host, port)
        glue = Glue.new(net_adapter, gui, player)

        glue.apply
        net_adapter.run
        gui.run!
      end
    end
  end
end
