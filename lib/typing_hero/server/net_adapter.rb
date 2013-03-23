require 'typing_hero/server/client_handler'

require 'socket'
module TypingHero
  module Server
    class NetAdapter

      def initialize(host = "0.0.0.0", port = 3100)
        @server = TCPServer.new(host, port)
        @clients = []
      end

      def run
        loop do
          client = ClientHandler.new(@server.accept)
          name = client.get_name
          client.listen(self)
          @clients << client
          client_connected(name, client)
        end
      end

      def send_world(words, players)
        @clients.each { |c| c.send_world(words, players) }
      end

      def word_received(client, word)
      end

      def client_connected(name, client)
        puts "Client connected"
      end

    end
  end
end
