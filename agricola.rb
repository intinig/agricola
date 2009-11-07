RED     = 0
WHITE   = 1
BLUE    = 2
GREEN   = 3
PURPLE  = 4

class Game
  def initialize(players_number)
    @players = []
    players_number.times do |i|
      @players = Player.new(i)
    end
    @players[rand(players_number)].starting_player = true
  end
end

class Board
end

class Farm
end

class Player
  attr_accessor :starting_player, :color, :farm
  
  def initialize(color)
    @color = color
    @farm = Farm.new
  end
end