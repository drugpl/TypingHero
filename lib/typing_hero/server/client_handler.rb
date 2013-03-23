require 'json'

module TypingHero
  module Server
    class ClientHandler
      def initialize(socket)
        @socket = socket
      end

      def listen(net_adapter)
        puts "LISTENING"
        Thread.new do
          loop do
            word_in_json = @socket.gets
            word = JSON.parse(word_in_json)["word"]
            net_adapter.word_received(word)
          end
        end
      end

      def send_world(words, players)
        world = build_world(words, players).to_json
        @socket.puts(world)
      end

      def build_world(words, players)
        mapped_words = words.map do |word|
          {
            :content => word.content,
            :position => word.position
          }
        end
        mapped_players = players.map do |player|
          {
            :name => player.name,
            :score => player.score
          }
        end
        {
          :words => mapped_words,
          :players => mapped_players
        }
      end

    end
  end
end
