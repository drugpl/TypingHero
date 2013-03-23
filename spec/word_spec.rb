require 'spec_helper'

describe TypingHero::Word do

  subject { TypingHero::Word.new("hello") }

  its(:position) { should == TypingHero::Position.new(0,0) }
  its(:content) { should == "hello" }
  its(:x) { should == 0 }
  its(:y) { should == 0 }

end
