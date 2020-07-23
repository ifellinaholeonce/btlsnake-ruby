class Snake
  attr_accessor :snake, :board, :head

  def initialize(); end

  def move(request)
    puts(request)
    self.snake = request[:you]
    self.board = request[:board]
    self.head = snake[:head]

    puts "Head: #{head}"

    move = possible_moves.sample
    puts "MOVE: #{move}"

    { "move": move }
  end

  private

  def direction_hash(x, y)
    {
      up: { x: x, y: y - 1 },
      down: { x: x, y: y + 1 },
      left: { x: x - 1, y: y },
      right: { x: x + 1, y: y }
    }
  end

  def possible_moves
    possible_moves = []
    direction_hash(head[:x], head[:y]).each do |k ,v|
      # don't run into tail
      next if snake[:body].include?(v)
      # don't leave board
      next if outside_board?(v)

      possible_moves << k.to_s
    end
    possible_moves
  end

  def moves_from_square(coords)
    # check each direction for empty space
  end

  def outside_board?(coords)
    x = coords[:x]
    y = coords[:y]
    return true if x.negative? || x >= board[:width]

    return true if y.negative? || y >= board[:height]

    false
  end
end
