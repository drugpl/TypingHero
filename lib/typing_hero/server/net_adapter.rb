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
          client = Client.new(@server.accept)
          client.listen(self)
          @clients << client
          client_connected(client)
        end
      end

      def send_world(words, players)
        @clients.each { |c| c.send_world(words, players) }
      end

      def word_received(word)
      end

      def client_connected(client)
        puts "Client connected"
      end

    end
  end
end
