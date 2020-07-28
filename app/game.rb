Dir['./app/lib/pathfinding/*.rb'].sort.each { |file| require file }


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

  def plot_direction
    str = map_graph
    graph = Graph.new(str)
    astar = ASTAR.new(graph.start, graph.stop)
    path  = astar.search
    puts graph.to_s(path)
    path
  end

  def map_graph
    map = ""
    # for each Y add a line like
    # "#0123456#"
    # which ends up looking like "# {0,0} {1,0}...#"
    board.height.times do |y|
      line = ""
      # for each X determine if square has an obstacle
      board.width.times do |x|
        line << "B" and next if board.food.include?({ x: x, y: y })
        line << "A" and next if snake.head == { x: x, y: y }

        case board.square_has_obstacle(x: x, y: y)
        when true
          line << "#"
        when false
          line << "-"
        end
      end
      line << "\n"
      map << line
    end
    map
  end
end
