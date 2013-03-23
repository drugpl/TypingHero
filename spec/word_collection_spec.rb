require 'spec_helper'

describe TypingHero::WordCollection do

  describe "empty" do

    subject { TypingHero::WordCollection.new }

    it { should be_empty }

  end

  describe "with one item" do

    subject { TypingHero::WordCollection.new(["hey"]) }

    its(:size) { should == 1 }

  end

end
