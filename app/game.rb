class Game
  attr_accessor :id, :board, :snake, :turn

  def initialize(id:)
    self.id = id
    self.turn = 0
  end

  def tick(request)
    self.turn = request[:game][:turn]
    board.update(request[:board])
    snake.update(player: request[:you], board: board)
  end
end
