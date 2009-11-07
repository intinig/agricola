require File.dirname(__FILE__) + "/../starting_card"

describe StartingCard do
  it "should have a number of players attribute" do
    s = StartingCard(:description => "2 Wood", :players => 3, :family => false, :fixed => {:wood => 2})
  end
end