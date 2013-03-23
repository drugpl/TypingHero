require 'typing_hero'

TypingHero::Client::App.new(ARGV[0] || 'localhost', (ARGV[1] || 3100).to_i)
