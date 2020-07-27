require 'knn'
require './app/lib/hacks/knn/vector.rb'

class Board
  attr_accessor :height, :width, :food, :snakes

  def initialize(board:, game:)
    self.height = board[:height]
    self.width = board[:width]
    self.food = board[:food]
    self.snakes = board[:snakes]
  end

  def update(board)
    self.height = board[:height]
    self.width = board[:width]
    self.food = board[:food]
    self.snakes = board[:snakes]
  end

  def outside_board?(x:, y:)
    return true if x.negative? || x >= width

    return true if y.negative? || y >= height

    false
  end

  def closest_food(x:, y:)
    foods = []
    food.each { |food| foods << Knn::Vector.new([food[:x], food[:y]], nil)}
    snake = Knn::Vector.new([x, y], nil)
    classifier = Knn::Classifier.new(foods, 3)
    coords = classifier.nearest_neighbours_to(snake).first.coordinates
    { x: coords[0], y: coords[1] }
  end

  def square_has_obstacle(x:, y:)
    coords = {x: x, y: y}
    return true if snakes.include?(coords)

    false
  end
end
