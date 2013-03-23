require 'curses'

module TypingHero
  class CursesGui
    include Curses

    COLORS = [
      COLOR_BLACK, COLOR_BLUE, COLOR_CYAN, COLOR_GREEN,
      COLOR_MAGENTA, COLOR_RED, COLOR_WHITE, COLOR_YELLOW
    ]

    class Job < Struct.new(:delay, :proc); end

    def initialize
      @current_text = ""
      @positions = {}
      @colors = {}
      @scores = {}
      @jobs = []
      @words = WordCollection.new
      @score = 0

      setup_curses
      setup_windows
    end

    def update_words(words)
      @words = words
    end

    def update_scores(scores)
      @scores = scores
      notify_scoreboard
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
      notify_textbox
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

    def notify_scoreboard
      @scores_changed = true
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
    end

    def setup_windows
      @stage_width = cols
      @stage_height = lines - 3
      @scoreboard_width = 22

      @stage = Window.new @stage_height, @stage_width, 0, 0
      @stage.timeout = 0

      @textbox = Window.new 3, @stage_width, @stage_height, 0
      @textbox.timeout = 0

      @scoreboard = Window.new @stage_height, @scoreboard_width, @stage_height, @stage_width - @scoreboard_width
      @scoreboard.timeout = 0

      notify_textbox
      notify_scoreboard
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
      @stage.noutrefresh

      if @textbox_changed
        @textbox.clear
        @textbox.box '|', '-'

        @textbox.setpos 1, 3
        @textbox << @current_text

        @textbox.setpos 1, @stage_width - 8
        @textbox << sprintf('| %4d', @score)

        @textbox.refresh

        @textbox_changed = false
      end

      if @scores_changed
        @scoreboard.clear
        @scoreboard.box '|', '-'
        display_scores
        @scoreboard.noutrefresh
      end
    end

    ##################################################

    def vertical_position_for(word)
      @positions[word.content] ||= rand(@stage_height)
    end

    def horizontal_position_for(word)
      word.position * (@stage_width - word.content.length)
    end

    def color_for(word)
      @colors[word.content] ||= COLORS.sample
    end

    def arrange_words
      @words.each do |word|
        @stage.setpos vertical_position_for(word), horizontal_position_for(word)
        @stage.color_set color_for(word)
        @stage << word.content
      end
    end

    def display_scores
      @scores.each_with_index do |val, i|
        name, player = val
        @scoreboard.setpos i+1, 2
        @scoreboard << sprintf("%#{@scoreboard_width - 9}s %4d", name, player.score)
      end
    end
  end
end
