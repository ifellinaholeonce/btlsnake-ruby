class Snake
  attr_accessor :snake, :board, :head
  def initialize()
  end

  def move(request)
    self.snake = request[:you]
    self.board = request[:board]
    self.head = snake[:head]

    legitimate_moves = []

    possible_moves.each do |k ,v|
      # don't run into tail
      next if snake[:body].include?(v)
      # don't leave board
      next if outside_board?(v)
      legitimate_moves << k.to_s
    end

    move = legitimate_moves.sample
    puts "move_list:"
    puts legitimate_moves
    puts "MOVE: " + move

    { "move": move }
  end

  private

  def possible_moves
    {
      up:     { x: head[:x], y: head[:y] + 1 },
      down:   { x: head[:x], y: head[:y] - 1 },
      left:   { x: head[:x] - 1, y: head[:y] },
      right:  { x: head[:x] + 1, y: head[:y] }
    }
  end

  def outside_board?(coords)
    x = coords[:x]
    y = coords[:y]
    return true if x < 0 || x > board[:width]
    return true if y < 0 || y > board[:height]
    return false
  end
end
