module TypingHero
  WORDS = %w(hello world lorem ipsum dolor amet)

  class App
    def initialize
      gui = CursesGui.new
      typing_hero = TypingHero.new(WORDS)
      glue = Glue.new(typing_hero, gui)

      glue.apply
      typing_hero.start
      gui.run!
    end
  end

end
