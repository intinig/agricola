require 'common'
require 'card_sets'

class Board
  attr_reader :starting_actions, :fixed_actions, :turn_actions
  
  def initialize(options = {})
    @players = options.delete(:players) || raise("Must specify number of players")
    @family_game = options.delete(:family_game)
    @starting_actions = CardSets::Starting.cards(:players => @players, :family_game => @family_game)
    @fixed_actions = CardSets::Fixed.cards(:family_game => @family_game)
    @turn_actions = CardSets::Turn.shuffled_cards
  end
  
  def family_game?
    @family_game == true
  end
end
