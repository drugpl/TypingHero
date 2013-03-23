require 'socket'

module TypingHero
  class NetServerAdapter

    def initialize(port)
      @server = TCPServer.new(port)
    end

    def run
      Thread.new do
        client = @server.accept
        loop do
          word = client.gets.chomp
          word_received(word)
        end
      end
    end

    def word_received(word)
    end

  end
end
