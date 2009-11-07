require File.dirname(__FILE__) + "/../action_card"

describe ActionCard do 
  it "should accept description" do
    a = ActionCard.new(:description => "2 Wood")
    a.description.should == "2 Wood"
  end
  
  it "should require description" do
    lambda {ActionCard.new()}.should raise_error
  end
  
  it "should store resources on it" do
    a = ActionCard.new(:description => "2 Wood")
    a.wood.should == 0
    a.add_resources(:wood => 6)
    a.wood.should == 6
  end
  
  it "should handle construction resources" do
    a = ActionCard.new(:description => "2 Wood", :wood => 1, :reed => 2, :clay => 3, :stone => 4)
    a.wood.should == 1
    a.reed.should == 2
    a.clay.should == 3
    a.stone.should == 4
  end
  
  it "should handle food" do
    a = ActionCard.new(:description => "2 Wood", :food => 1)
    a.food.should == 1
  end
  
  it "should handle animals" do
    a = ActionCard.new(:description => "2 Wood", :sheep => 1, :boar => 2, :cattle => 3)
    a.sheep.should == 1
    a.boar.should == 2
    a.cattle.should == 3
  end
  
  it "should handle grain and vegetables" do
    a = ActionCard.new(:description => "2 Wood", :vegetable => 1, :grain => 1)
    a.grain.should == 1
    a.vegetable.should == 1
  end
  
  it "should allow playing an occupation" do
    a = ActionCard.new(:description => "1 Occupation", :occupation => [{:food => 0}, {:food => 1}])
    a.allows_occupation?.should be_true
    a.occupation_price(0).should == {:food => 0}
    a.occupation_price(1).should == {:food => 1}
    a.occupation_price(2).should == {:food => 1}
    a.occupation_price(5).should == {:food => 1}
  end
  
  it "should allow building a room" do
    a = ActionCard.new(:description => "Build 1 Room", 
      :rooms => {
        :wood => {:cost => {:wood => 5, :reed => 2}, :multiple => true},
        :clay => {:cost => {:clay => 5, :reed => 2}, :multiple => true},
        :stone => {:cost => {:stone => 5, :reed => 2}}
      }
    )
    
    a.allows_building_rooms?(:wood).should be_true
    a.allows_building_rooms?(:clay).should be_true
    a.allows_building_rooms?(:stone).should be_true
    
    a.room_price(:wood).should == {:wood => 5, :reed => 2}
    a.room_price(:clay).should == {:clay => 5, :reed => 2}
    a.room_price(:stone).should == {:stone => 5, :reed => 2}
    a.allows_building_multiple_rooms?(:wood).should be_true
    a.allows_building_multiple_rooms?(:clay).should be_true
    a.allows_building_multiple_rooms?(:stone).should_not be_true
  end
  
  it "should allow fixed amounts of resources" do
    a = ActionCard.new(:description => "2 Wood", :fixed => {:wood => 2})
    a.act!.should == {:resources => {:wood => 2}}
    a.next_turn!
    a.act!.should == {:resources => {:wood => 2}}
  end
  
  it "should allow per_turn amounts of resources" do
    a = ActionCard.new(:description => "2 Wood", :per_turn => {:wood => 2})
    a.act!.should == {:resources => {}}
    a.next_turn!
    a.act!.should == {:resources => {:wood => 2}}
    a.next_turn!
    a.next_turn!
    a.next_turn!
    a.act!.should == {:resources => {:wood => 6}}
  end
  
  it "should allow mixed resources" do
    a = ActionCard.new(:description => "1 Reed + 1 Stone and 1 Wood", :per_turn => {:reed => 1}, :fixed => {:wood => 1, :stone => 1})
    a.next_turn!
    a.next_turn!
    a.act!.should == {:resources => {:reed => 2, :wood => 1, :stone => 1}}
    a.act!.should == {:resources => {:wood => 1, :stone => 1}}
  end
  
  it "should allow A or B effects" do
    food = ActionCard.new(:description => "1 Food", :per_turn => {:food => 1})
    a = ActionCard.new(:description => "2 Wood or 1 Food", :per_turn => {:wood => 2}, :or => food)
    a.next_turn!
    a.act!(:or => true).should == {:resources => {:food => 1}}
    a.next_turn!
    a.wood.should == 4
    a.or_card.food.should == 1
  end
  
  it "should allow A and/or B effects" do
    pending
  end
end