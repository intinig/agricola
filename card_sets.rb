require 'action_card'

module CardSets
  class Fixed
    def self.cards
      @cards ||= []
      if @cards.empty?
        build_stable = ActionCard.new(:description => "Costruisci Stalla(e)")
        @cards << ActionCard.new(:description => "Costruisci Stanza(e)", 
          :rooms => {
            :wood => {:cost => {:wood => 5, :reed => 2}, :multiple => true},
            :clay => {:cost => {:clay => 5, :reed => 2}, :multiple => true},
            :stone => {:cost => {:stone => 5, :reed => 2}, :multiple => true}
          }, :and_or => build_stable
        )
      
        minor_improvement = ActionCard.new(:description => "1 Piccolo Miglioramento")
        @cards << ActionCard.new(:description => "Primo Giocatore", :and_or => minor_improvement)
      
        @cards << ActionCard.new(:description => "Prendi un Grano", :fixed => {:grain => 1})
      
        @cards << ActionCard.new(:description => "Ara 1 Campo")
      
        @cards << ActionCard.new(:description => "1 Occupazione", :occupation => [{:food => 0}, {:food => 1}])
      
        @cards << ActionCard.new(:description => "Braccciante", :fixed => {:food => 2})
      
        @cards << ActionCard.new(:description => "3 Legno", :per_turn => {:wood => 3})
      
        @cards << ActionCard.new(:description => "1 Argilla", :per_turn => {:clay => 1})
      
        @cards << ActionCard.new(:description => "1 Canna", :per_turn => {:reed => 1})
      
        @cards << ActionCard.new(:description => "Pescare", :per_turn => {:food => 1})
      end
      @cards
    end
  end
end