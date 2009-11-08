require File.dirname(__FILE__) + "/../board"

describe Board do
  before do
    @board = Board.new(:players => 4)
  end
  it "should require number of players" do
    lambda {Board.new(:family_game => true)}.should raise_error
  end
  
  it "should default to full game" do
    b = Board.new(:players => 3)
    b.family_game?.should be_false
  end
  
  it "should set family_game" do
    b = Board.new(:players => 3, :family_game => true)
    b.family_game?.should be_true
  end
    
  it "should load the correct cards for 2 players normal game" do
    CardSets::Starting.should_receive(:cards).with(:players => 2, :family_game => nil)
    CardSets::Fixed.should_receive(:cards).with(:family_game => nil)
    CardSets::Turn.should_receive(:shuffled_cards)
    Board.new(:players => 2)
  end

  it "should load the correct cards for 4 players family game" do
    CardSets::Starting.should_receive(:cards).with(:players => 4, :family_game => true)
    CardSets::Fixed.should_receive(:cards).with(:family_game => true)
    CardSets::Turn.should_receive(:shuffled_cards)
    Board.new(:players => 4, :family_game => true)
  end
end