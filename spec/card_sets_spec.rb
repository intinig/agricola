require File.dirname(__FILE__) + "/../card_sets"

describe CardSets::Fixed do
  it "should have the basic cards" do
    CardSets::Fixed.cards.size.should == 10
  end
end