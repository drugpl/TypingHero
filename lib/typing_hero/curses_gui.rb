require 'curses'

module TypingHero
  class CursesGui
    include Curses

    def initialize
      @current_text = ""

      setup_curses
      setup_textbox
    end

    def tick
      handle_input

      display_textbox
    end

    def run!
      begin
        loop do
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
    end

    def setup_textbox
      @textbox = Window.new 3, cols, lines - 3, 0
      @textbox.timeout = 0
    end

    def handle_input
      char = @textbox.getch

      if char.is_a?(String)
        case char
        when '['
          # Ignore the next charactor
          @textbox.getch
        else @current_text << char
        end
      else
        case char
        when 127 # backspace
          # @current_text = @current_text[0..-2]
        end
      end
    end

    def display_textbox
      @textbox.clear
      @textbox.box '|', '-'
      @textbox.setpos 1, 2
      @textbox << @current_text
      @textbox.refresh
    end
  end
end
