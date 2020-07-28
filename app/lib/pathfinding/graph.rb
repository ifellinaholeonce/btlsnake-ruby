class Graph
  attr_reader :start, :stop

  def initialize(d, start = "A", stop = "B",
                 obst = "#", empty = " ", out = "*")

    [d, start, stop, obst, empty, out].each do |input|
      raise ArgumentError,
        "All arguments must be a String\n" +
        "Received a #{input.class} instead" unless input.is_a? String
    end

    [start, stop, obst, empty, out].each do |input|
      raise ArgumentError,
        "Character specification must be of size 1\n" +
        "Received a String with size #{input.size}" unless input.size == 1
    end

    @a = start
    @b = stop
    @o = obst
    @s = empty
    @p = out

    # It's now the time to convert the input in some sort of matrix
    # so that will be easier to create the connectivity. The
    # two methods used are explained here:
    # split: https://ruby-doc.org/core-2.4.0/String.html#method-i-split
    # map: https://ruby-doc.org/core-2.4.0/Array.html#method-i-map
    @str = d.split("\n").map { |e| e.split("") }

    # Let's read the number of rows and of columns and check the
    # consistency
    @rows, @cols = @str.size, @str[0].size
    @str.each_with_index do |r, i|
      raise ArgumentError,
        "The number of columns of the input string is not consistent.\n" +
        "Row #{i} contains #{r.size} chars instead of #{@cols}.\n" +
        "Please chech for spaces at the end of the row" unless r.size == @cols
    end # each_with_index

    # We are now building the @dungeon matrix, that is used to create the nodes
    # Where there are obstacles, we leave a nil
    @dungeon = Array.new(@rows) { Array.new(@cols) { nil } }

    # We search for starting and stopping point and we create the
    # @start and @stop attributes in that points. If no @start
    # or no @stop is found, it raises an Error
    str_each do |v, r, c|
      @start = Node.new(r, c) if v.upcase == @a
      @stop  = Node.new(r, c) if v.upcase == @b
    end
    raise ArgumentError,
      "The string provided does not contain a starting point " +
      "with char = #{@a}" unless @start
    raise ArgumentError,
      "The string provided does not contain a stopping point " +
      "with char = #{@b}" unless @stop

    # Let's assign a value for each position of the dungeon
    #  - @a: the it is the start node
    #  - @b: then it is the stop node
    #  - @o: then it is an obstacle node and its with a nil
    #  - else: let's put inside a new node
    map do |v, r, c|
      s = @str[r][c]
      if s == @a
        @start
      elsif s == @b
        @stop
      elsif s == @o
        nil
      elsif s == @s
        Node.new(r, c)
      else
        raise ArgumentError,
          "Unknown char found in string: #{s}"
      end
    end

    # It's time to build the connectivity of the graph. If there
    # is something near the current node, that it is added to the
    # near attribute of the node.
    # == PLEASE NOTE ==
    # We are using only the four directions in space, but it is
    # easy to expand it to the four direction in space by
    # adding the directions in the array.
    each do |v, r, c|
      next unless v
      [[r + 1, c],
       [r, c + 1],
       [r - 1, c],
       [r, c - 1]].each do |p|
        next unless inside?(p[0], p[1])
        v.insert(@dungeon[p[0]][p[1]]) if @dungeon[p[0]][p[1]]
      end
    end
  end # initialize

  ##
  # Print the dungeon. If a path (Array of Nodes) is given as input
  # it will be printed on the screen using chars @p
  def to_s(path = nil)
    str_ = @str.map(&:dup)
    if path
      raise ArgumentError,
        "Input must be an Array.\n" +
        "Received a #{path.class}" unless path.is_a? Array
      for n in path[0...path.size-1]
        raise ArgumentError,
          "Input must contain all Nodes.\n" +
          "Received a #{n.class}" unless n.is_a? Node
        str_[n.r][n.c] = @p.yellow
      end
    end
    str_ = str_.map { |l| l.join}
    return str_
  end # print_path

  private

  ##
  # Acts on each element of @str, and calls a block
  # that receives the value in position, the row number
  # and the column number
  def str_each
    for r in 0...@rows
      for c in 0...@cols
        yield(@str[r][c], r, c)
      end
    end
    return @str
  end # str_each

  ##
  # Acts on each element of @dungeon, and calls a block
  # that receives the value in position, the row number
  # and the column number.
  # It modifies the content of @dungeon.
  def map
    for r in 0...@rows
      for c in 0...@cols
        @dungeon[r][c] = yield(@dungeon[r][c], r, c)
      end
    end
    return @dungeon
  end # map

  ##
  # Acts on each element of @dungeon, and calls a block
  # that receives the value in position, the row number
  # and the column number.
  def each
    for r in 0...@rows
      for c in 0...@cols
        yield(@dungeon[r][c], r, c)
      end
    end
    return @dungeon
  end # map


  ##
  # Specify if we are inside or outside of the matrix
  def inside?(r, c)
    return ((0...@rows).include?(r) and (0...@cols).include?(c))
  end # inside?

end # Graph


class String
  def yellow
    "\033[1;33m" + self + "\033[0m"
  end
end