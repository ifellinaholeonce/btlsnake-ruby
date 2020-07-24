class Snake
  attr_accessor :snake, :board, :head

  def initialize(request)
    self.snake = request[:you]
    self.board = request[:board]
    self.head = snake[:head]
  end

  def move
    puts "Head: #{head}"

    possible_moves = possible_moves_from_square(head[:x], head[:y])

    # will a random direction have a move after? dont trap yourself
    move = calculate_next_step(possible_moves)

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
      up: { x: x, y: y - 1 },
      down: { x: x, y: y + 1 },
      left: { x: x - 1, y: y },
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

      possible_moves << k.to_s
    end
    possible_moves
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
    return true if x.negative? || x >= board[:width]

    return true if y.negative? || y >= board[:height]

    false
  end
end
