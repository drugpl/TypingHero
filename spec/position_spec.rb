require 'spec_helper'

describe TypingHero::Position do

  describe "without arguments" do
    subject { TypingHero::Position.new }

    its(:x) { should == 0 }
    its(:y) { should == 0 }
  end

  describe "with arguments" do
    subject { TypingHero::Position.new(10, 20) }

    its(:x) { should == 10 }
    its(:y) { should == 20 }
  end

  describe "changed" do
    subject { TypingHero::Position.new(20, 30) }

    before do
      subject.x = 100
      subject.y = 200
    end

    its(:x) { should == 100 }
    its(:y) { should == 200 }

  end

end
