require 'spec_helper'

describe TypingHero::TypingHero do
  let(:dude)  { TypingHero::Word.new("dude") }
  let(:bro)  { TypingHero::Word.new("bro") }
  let(:words) { TypingHero::WordCollection.new([dude, bro]) }
  let(:player) { TypingHero::Player.new }

  subject { TypingHero::TypingHero.new(words) }

  it "starts the game" do
    subject.start
    subject.visible_words.should == [dude]
  end

  describe "when a time unit has been elapsed" do

    it "moves the words" do
      expect {
        subject.time_unit_elapsed
      }.to change { dude.position }.by(0.01)
    end

  end

  describe "when player entered a word correctly" do
    it "should add points" do
      expect {
        subject.player_entered_word(player, "dude")
      }.to change{player.score}.by("dude".size)
    end

    it "should draw next word" do
      subject.player_entered_word(player, "dude")
      subject.visible_words.should == [bro]
    end
  end

  describe "when player entered a word incorrectly" do

    it "should not add points" do
      expect {
        subject.player_entered_word(player, "hello")
      }.not_to change{player.score}
    end

    it "should stay with current word" do
      subject.player_entered_word(player, "hello")
      subject.visible_words.should == [dude]
    end

  end

end
