require 'spec_helper'

describe TypingHero::Word do

  subject { TypingHero::Word.new("hello") }

  its(:position) { should == 0 }
  its(:content) { should == "hello" }
  its(:size) { should == 5 }

  it "increases position" do
    expect {
      subject.increase_position
    }.to change { subject.position }.by(0.01)
  end

end
