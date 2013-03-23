module TypingHero
  WORDS = %w(hello world lorem ipsum dolor amet)

  class App
    def initialize
      gui = CursesGui.new
      typing_hero = TypingHero.new(WORDS)
      time_adapter = TimeAdapter.new(1)
      glue = Glue.new(typing_hero, gui, time_adapter)

      glue.apply
      typing_hero.start
      gui.run!
    end
  end

end
