# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
# Valid moves are "up", "down", "left", or "right".
# TODO: Use the information in board to decide your next move.
def move(request)
  board = request[:board]
  snake = request[:you]
  puts board
  puts snake
  head = snake[:head] # { x: 5, y: 0 }

  possible_moves = calculate_possible_moves(head, board)
  move = possible_moves.sample
  puts "MOVE: " + move
  { "move": move }
end

def calculate_possible_moves(head, board)
  board_x_max = board[:width]
  board_y_max = board[:height]
  possible_moves = ["up", "down", "left", "right"]

  possible_moves.delete("left") if head[:x] == 0
  possible_moves.delete("right") if head[:x] == board_x_max
  possible_moves.delete("down") if head[:y] == 0
  possible_moves.delete("up") if head[:y] == board_y_max
  possible_moves
end
