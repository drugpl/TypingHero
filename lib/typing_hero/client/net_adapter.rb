require 'socket'
require 'json'

module TypingHero
  module Client
    class NetAdapter
      def initialize(host, port)
        @socket = TCPSocket.new(host, port)
      end

      def start
      end

      def run
        start
        Thread.new do
          while line = @socket.gets
            process_message(line)
          end
          @socket.close
        end
      end

      def process_message(line)
        json = JSON.load(line)

        case json['type']
        when 'world'
          world_updated({
            players: Hash[json['players'].map { |p| [ p['name'], Player.new(p['name'], p['score']) ] }],
            words: json['words'].map { |w| Word.new(w['content'], w['position']) }
          })
        when 'word_correct'
          word_correct(json['word'])
        end
      end

      def send_message(message)
        @socket.puts(JSON.dump(message))
      end

      def world_updated(message)
      end

      def word_correct(word)
      end
    end
  end
end