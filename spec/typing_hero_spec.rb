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
      }.to change { dude.x }.by(1)
    end

  end

  describe "when player typed a word correctly" do
    it "should add points" do
      expect {
        subject.player_typed_word(player, "dude")
      }.to change{player.score}.by(1)
    end

    it "should draw next word" do
      subject.player_typed_word(player, "dude")
      subject.visible_words.should == [bro]
    end
  end

  describe "when player typed a word incorrectly" do

    it "should not add points" do
      expect {
        subject.player_typed_word(player, "hello")
      }.not_to change{player.score}
    end

    it "should stay with current word" do
      subject.player_typed_word(player, "hello")
      subject.visible_words.should == [dude]
    end

  end

end
