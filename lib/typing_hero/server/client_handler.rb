require 'json'

module TypingHero
  module Server
    class ClientHandler
      def initialize(socket)
        @socket = socket
      end

      def get_name
        name_in_json = @socket.gets
        JSON.parse(name_in_json)["player"]
      end

      def listen(net_adapter)
        Thread.new do
          loop do
            begin
              word_in_json = @socket.gets
              word = JSON.parse(word_in_json)["word"]
              net_adapter.word_received(self, word)
            rescue Errno::EPIPE, Errno::ECONNREFUSED
            end
          end
        end
      end

      def send_world(words, players)
        world = build_world(words, players)
        puts(world)
      end

      def inform_about_correct_word(word)
        puts(
            :type => "word_correct",
            :word => word.content
        )
      end

      def inform_about_incorrect_word
        puts(:type => "word_incorrect")
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
          :type => "world",
          :words => mapped_words,
          :players => mapped_players
        }
      end

      def puts(message)
        begin
          @socket.puts(message.to_json)
        rescue Errno::EPIPE, Errno::ECONNREFUSED
        end
      end

    end
  end
end
