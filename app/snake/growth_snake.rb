require './app/snake'

# This subclass will prioritize growth over all else
class GrowthSnake < Snake
  attr_accessor :snake, :head, :board

  def initialize(player:, board:)
    self.board = board
    self.snake = player
    self.head = snake[:head]
  end

  def move
    super
  end

  private

  def calculate_next_step(possible_moves)
    # move towards the closest food on the X axis if able
    dir_x = get_dir_to_x_coord(closest_food[:x])
    dir_y = get_dir_to_y_coord(closest_food[:y])
    if dir_x # left or right
      new_head_coords = mutate_coords_by_dir(head[:x], head[:y], dir_x)
      dir_x if possible_moves_from_square(new_head_coords[:x], new_head_coords[:y])
    elsif dir_y
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

  def closest_food
    @closest_food ||= board.closest_food(x: head[:x], y: head[:y])
  end
end
