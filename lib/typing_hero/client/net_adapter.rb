require 'socket'
require 'json'

module TypingHero
  module Client
    class NetAdapter
      def initialize(host, port)
        @socket = TCPSocket.new(host, port)
      end

      def run
        Thread.new do
          while line = @socket.gets
            process_message(line)
          end
          @socket.close
        end
      end

      def process_message(line)
        json = JSON.load(line)

        message_received({
          players: json['players'].map { |p| Player.new(p['name'], p['score']) },
          words: json['words'].map { |w| Word.new(w['content'], w['position']) }
        })
      end

      def send_message(message)
        @socket.puts(JSON.dump(message))
      end

      def message_received(message)
      end
    end
  end
end