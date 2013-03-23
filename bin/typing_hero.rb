require 'typing_hero'

speed = (ARGV[0] || 1).to_f

TypingHero::App.new(speed)
