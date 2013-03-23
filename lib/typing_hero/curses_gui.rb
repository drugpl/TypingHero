require 'curses'

module TypingHero
  class CursesGui
    include Curses

    COLORS = [
      COLOR_BLACK, COLOR_BLUE, COLOR_CYAN, COLOR_GREEN,
      COLOR_MAGENTA, COLOR_RED, COLOR_WHITE, COLOR_YELLOW
    ]

    COLOR_ERROR = 666

    class Job < Struct.new(:delay, :proc); end

    def initialize
      @current_text = ""
      @positions = {}
      @colors = {}
      @jobs = []
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
      notify_textbox
    end

    def word_entered(word)
      notify_textbox
    end

    def word_correct(word)
      @current_text = ''
      @positions.delete(word)
    end

    def word_incorrect
      @textbox.color_set COLOR_RED
      notify_textbox

      delay(15) do
        @textbox.bkgd COLOR_WHITE
        notify_textbox
      end
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

    def tick
      handle_input
      run_delayed_jobs
      display_windows
    end

    def notify_textbox
      @textbox_changed = true
    end

    def delay(interval, &block)
      @jobs.push Job.new(interval, block)
    end

    def run_delayed_jobs
      @jobs.each do |job|
        job.delay -= 1
        job.proc.call if job.delay == 0
      end

      @jobs.delete_if { |job| job.delay == 0 }
    end

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

      init_pair(COLOR_ERROR, COLOR_BLACK, COLOR_RED)
    end

    def setup_windows
      @stage_width = cols
      @stage_height = lines - 3

      @stage = Window.new @stage_height, @stage_width, 0, 0
      @stage.timeout = 0

      @textbox = Window.new 3, @stage_width, @stage_height, 0
      @textbox.timeout = 0

      notify_textbox
    end

    def handle_input
      char = @textbox.getch

      if char.is_a?(String)
        case char
        when '['
          # Ignore the next characters
          @textbox.getstr
        else
          @current_text << char
          notify_textbox
        end
      else
        case char
        when 10 # enter
          word_entered @current_text
        when 27 # cheat na esc
          @current_text = ''
          notify_textbox
        when 127 # backspace
          @current_text = @current_text[0..-2]
          notify_textbox
        end
      end
    end

    def display_windows
      @stage.clear
      arrange_words
      @stage.refresh

      if @textbox_changed
        @textbox.clear
        @textbox.box '|', '-'

        @textbox.setpos 1, 2
        @textbox << @current_text

        @textbox.setpos 1, @stage_width - 9
        @textbox << sprintf('| %5d', @score)

        @textbox.refresh

        @textbox_changed = false
      end
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
