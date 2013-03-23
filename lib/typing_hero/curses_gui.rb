require 'curses'

module TypingHero
  class CursesGui
    include Curses

    COLORS = [
      COLOR_BLACK, COLOR_BLUE, COLOR_CYAN, COLOR_GREEN,
      COLOR_MAGENTA, COLOR_RED, COLOR_WHITE, COLOR_YELLOW
    ]

    def initialize
      @current_text = ""
      @positions = {}
      @colors = {}
      @words = WordCollection.new
      @score = 0

      setup_curses
      setup_windows
    end

    def update_words(words)
      @words = words
    end

    def update_score(score)
      @score = score
    end

    def word_entered(word)
    end

    def word_correct(word)
      @current_text = ''
      @positions.delete(word)
    end

    def word_incorrect(word)
    end

    def run!
      begin
        loop do
          # Stop on ^C
          trap('INT') { raise StopIteration }

          tick
          sleep 0.04
        end
      ensure
        close_screen
      end
    end

    private

    def setup_curses
      init_screen
      start_color
      cbreak
      noecho
      stdscr.nodelay = 1
      curs_set(0)

      [
        COLOR_WHITE, COLOR_RED, COLOR_BLUE, COLOR_GREEN, COLOR_CYAN,
        COLOR_MAGENTA, COLOR_YELLOW
      ].each do |color|
        init_pair(color, color, COLOR_BLACK)
      end
    end

    def setup_windows
      @stage_width = cols
      @stage_height = lines - 3

      @stage = Window.new @stage_height, @stage_width, 0, 0
      @stage.timeout = 0

      @textbox = Window.new 3, @stage_width, @stage_height, 0
      @textbox.timeout = 0
    end

    def handle_input
      char = @textbox.getch

      if char.is_a?(String)
        case char
        when '['
          # Ignore the next characters
          @textbox.getstr
        else @current_text << char
        end
      else
        case char
        when 10 # enter
          word_entered @current_text
        when 27 # cheat na esc
          @current_text = ''
        when 127 # backspace
          @current_text = @current_text[0..-2]
        end
      end
    end

    def display_windows
      @stage.clear
      arrange_words
      @stage.refresh

      @textbox.clear
      @textbox.box '|', '-'

      @textbox.setpos 1, 2
      @textbox << @current_text

      @textbox.setpos 1, @stage_width - 9
      @textbox << sprintf('| %5d', @score)

      @textbox.refresh
    end

    def tick
      handle_input
      display_windows
    end

    ##################################################

    def vertical_position_for(word)
      @positions[word] ||= rand(@stage_height)
    end

    def horizontal_position_for(word)
      word.position * (@stage_width - word.content.length)
    end

    def color_for(word)
      @colors[word] ||= COLORS.sample
    end

    def arrange_words
      @words.each do |word|
        @stage.setpos vertical_position_for(word), horizontal_position_for(word)
        @stage.color_set color_for(word)
        @stage << word.content
      end
    end
  end
end
