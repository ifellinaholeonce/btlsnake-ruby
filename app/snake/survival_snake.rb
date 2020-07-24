require './app/snake'

# This subclass will prioritize survival over all else
class SurvivalSnake < Snake
  def initialize(request)
    self.snake = request[:you]
    self.board = request[:board]
    self.head = snake[:head]
  end

  def move(request)
    super
  end

  private

  def calculate_next_step(possible_moves)
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
