require './app/snake'
require 'knn'
require './app/lib/hacks/knn/vector.rb'

# This subclass will prioritize growth over all else
class GrowthSnake < Snake
  attr_accessor :snake, :head, :board, :game

  def initialize(player:, board:, game:)
    self.game = game
    self.board = board
    self.snake = player
    self.head = snake[:head]
  end

  def move
    super
  end

  private

  def calculate_next_step(possible_moves)
    if astar_enabled?
      return "up" if board.food.include?(mutate_coords_by_dir(head[:x], head[:y], "up"))
      return "down" if board.food.include?(mutate_coords_by_dir(head[:x], head[:y], "down"))
      return "left" if board.food.include?(mutate_coords_by_dir(head[:x], head[:y], "left"))
      return "right" if board.food.include?(mutate_coords_by_dir(head[:x], head[:y], "right"))

      path = game.plot_direction
      unless path.empty?
        coords_to_move_to = {x: path.first.c, y: path.first.r }
        puts coords_to_move_to
        dir = get_dir_to_x_coord(coords_to_move_to[:x]) || get_dir_to_y_coord(coords_to_move_to[:y])
        puts "dir: #{dir}"
        return dir
      end
    end
    if dir.nil?
      # move towards the closest food on the X axis if able
      dir_x = get_dir_to_x_coord(closest_food[:x])
      dir_y = get_dir_to_y_coord(closest_food[:y])
      if dir_x && possible_moves.include?(dir_x) # left or right
        new_head_coords = mutate_coords_by_dir(head[:x], head[:y], dir_x)
        dir_x if possible_moves_from_square(new_head_coords[:x], new_head_coords[:y])
      elsif dir_y && possible_moves.include?(dir_y)
        new_head_coords = mutate_coords_by_dir(head[:x], head[:y], dir_y)
        dir_y if possible_moves_from_square(new_head_coords[:x], new_head_coords[:y])
      else
        dir = possible_moves.sample
        new_head_coords = mutate_coords_by_dir(head[:x], head[:y], dir)
        if possible_moves_from_square(new_head_coords[:x], new_head_coords[:y])
          dir
        else
          possible_moves.delete(dir)
          return dir if possible_moves.empty?

          calculate_next_step(possible_moves)
        end
      end
    end
  end

  def astar_enabled?
    true
  end

  def closest_food
    board.closest_food(x: head[:x], y: head[:y])
  end

  def take_special_first_move?
    true
  end

  def special_first_move
    possible_moves = ["up", "down", "left", "right"]
    dir = possible_moves.sample
    # move away from all snakes on first move
    snakes = []
    board.snakes.each do |s|
      next if s[:id] == snake[:id]

      snakes << Knn::Vector.new([s[:head][:x], s[:head][:y]], nil)
    end
    # get closes 2
    player_vector = Knn::Vector.new([snake[:head][:x], snake[:head][:y]], nil)
    classifier = Knn::Classifier.new(snakes, 3)
    coords = classifier.nearest_neighbours_to(player_vector).first(2)
    coords.each do |coord|
      coord_hash = { x: coord.coordinates.first, y: coord.coordinates.second }
      if coord_hash[:x] == snake[:head][:x]
        dir = get_opposite_dir(get_dir_to_y_coord(coord_hash[:y]))
      end
      if coord_hash[:y] == snake[:head][:y]
        dir = get_opposite_dir(get_dir_to_y_coord(coord_hash[:x]))
      end
    end

    dir
  end
end
