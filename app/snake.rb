class Snake
  # TODO: IGNORE TAIL AS OBSTACLE (UNLESS JUST GOT FOOD)
  attr_accessor :snake, :head, :board, :game
  def initialize(player:, board:, game:)
    self.board = board
    self.game
    self.snake = player
    self.head = snake[:head]
  end

  def update(player:, board:)
    self.board = board
    self.snake = player
    self.head = snake[:head]
  end

  def move
    puts "Head: #{head}"

    move = special_first_move if take_special_first_move? && game.turn == 0

    if move.nil?
      possible_moves = possible_moves_from_square(head[:x], head[:y])

      # will a random direction have a move after? dont trap yourself
      move = calculate_next_step(possible_moves)
    end

    puts "MOVE: #{move}"
    { "move": move }
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

  def direction_hash(x, y)
    {
      up:    { x: x, y: y + 1 },
      down:  { x: x, y: y - 1 },
      left:  { x: x - 1, y: y },
      right: { x: x + 1, y: y }
    }
  end

  def possible_moves_from_square(x, y)
    possible_moves = []
    direction_hash(head[:x], head[:y]).each do |k ,v|
      # don't run into tail
      next if snake[:body].include?(v)
      # don't leave board
      next if outside_board?(v[:x], v[:y])
      # look out for other snakes
      next if board.square_has_obstacle(x: v[:x], y: v[:y])

      possible_moves << k.to_s
    end
    possible_moves
  end

  def get_dir_to_x_coord(x)
    return "right" if x > head[:x]
    return "left" if x < head[:x]

    nil
  end

  def get_dir_to_y_coord(y)
    return "down" if y > head[:y]
    return "up" if y < head[:y]

    nil
  end

  def get_opposite_dir(dir)
    dirs = {
      up: "down",
      down: "up",
      left: "right",
      right: "left"
    }
    dirs[dir.to_sym]
  end

  def mutate_coords_by_dir(x, y, dir)
    coords = {x: x, y: y}
    case dir
    when "up"
      coords[:y] -= 1
    when "down"
      coords[:y] += 1
    when "left"
      coords[:x] -= 1
    when "right"
      coords[:x] += 1
    end
    coords
  end

  def outside_board?(x, y)
    board.outside_board?(x: x, y: y)
  end

  def take_special_first_move?
    false
  end

  def special_first_move
    nil
  end
end
