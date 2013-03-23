module TypingHero
  class TypingHero

    attr_reader :visible_words, :available_words, :players

    def initialize(available_words)
      @available_words = available_words
      @visible_words = [available_words.shift]
      @players = []
    end

    def start
    end

    def new_player_joined(name)
      @players << Player.new(name)
    end

    def time_unit_elapsed
      visible_words.each do |word|
        word.increase_position
      end
    end

    def player_entered_word(player, word)
      found_word = visible_words.detect { |w| w.content == word }
      if found_word
        player_correctly_entered_word(player, found_word)
      end
    end

    def player_correctly_entered_word(player, word)
      visible_words.delete(word)
      visible_words << available_words.shift
      player.add_points(word.size)
    end

    def last_player
      @players.last
    end

  end
end
