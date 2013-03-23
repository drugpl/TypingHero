module TypingHero
  class TimeAdapter

    def initialize(intervalInSeconds)
      @intervalInSeconds = intervalInSeconds
    end

    def start
      Thread.new do
        loop do
          sleep(@intervalInSeconds)
          tick
        end
      end
    end

    def tick
    end

  end
end
