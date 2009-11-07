require File.dirname(__FILE__) + "/../board"

describe Board do
  it "should have action cards" do
    Board.new(3).should respond_to(:actions)
  end
end

describe Board, "initialization" do
end