module TypingHero
  WORDS = %w(hello world lorem ipsum dolor amet)

  class App
    def initialize(speed = 1)
      gui = CursesGui.new
      player = Player.new("john")
      typing_hero = TypingHero.new(WORDS.map { |word| Word.new(word) })
      time_adapter = TimeAdapter.new(speed)
      glue = Glue.new(typing_hero, gui, time_adapter, player)

      glue.apply
      typing_hero.start
      gui.run!
    end
  end

end
