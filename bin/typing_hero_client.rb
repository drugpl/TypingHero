require 'typing_hero'

TypingHero::Client::App.new(ARGV[0], ARGV[1] || 'localhost', (ARGV[2] || 3100).to_i)
