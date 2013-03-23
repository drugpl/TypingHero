require 'spec_helper'

describe TypingHero::Player do

  describe "new" do
    its(:score) { should == 0 }
    its(:name) { should == "Anonymous" }

    it "can gain points" do
      subject.add_points(1)
      subject.score.should == 1
    end
  end

  describe "with name" do
    subject { TypingHero::Player.new("john") }

    it "should have a name" do
      subject.name.should == "john"
    end
  end

end
