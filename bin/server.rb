require 'typing_hero/server/app'

words = File.open(File.expand_path("../../fixtures/words", __FILE__)).readlines.map { |w| w.chomp }

TypingHero::Server::App.new(words)

