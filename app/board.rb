class Board
  attr_accessor :height, :width, :food, :snakes

  def initialize(board)
    self.height = board[:height]
    self.width = board[:width]
    self.food = board[:food]
    self.snakes = board[:snakes]
  end

  def outside_board?(x, y)
    return true if x.negative? || x >= width

    return true if y.negative? || y >= height

    false
  end

  def closest_food(x, y)
  end
end
