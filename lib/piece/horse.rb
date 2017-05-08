class Horse < Piece

  attr_accessor :pos, :color, :valid_moves, :board, :blockage

  def initialize(pos = [0, 0], color, board)
    @pos = pos
    @color = color
    @board = board
    @valid_moves = []
    possible_moves
  end

  def possible_moves
    row = pos[0]
    col = pos[1]

    #up
    if row - 2 >= 0 && col - 1 >= 0
      @blockage = false
      find_blockage(row - 2, col - 1)
    end
    if row - 2 >= 0 && col + 1 <= 7
      @blockage = false
      find_blockage(row - 2, col + 1)
    end

    #down
    if row + 2 <= 7 && col - 1 >= 0
      @blockage = false
      find_blockage(row + 2, col - 1)
    end
    if row + 2 <= 7 && col + 1 <= 7
      @blockage = false
      find_blockage(row + 2, col + 1)
    end

    #left
    if row - 1 >= 0 && col - 2 >= 0
      @blockage = false
      find_blockage(row - 1, col - 2)
    end
    if row + 1 <= 7 && col - 2 >= 0
      @blockage = false
      find_blockage(row + 1, col - 2)
    end

    #right
    if row - 1 >= 0 && col + 2 <= 7
      @blockage = false
      find_blockage(row - 1, col + 2)
    end
    if row + 1 <= 7 && col + 2 <= 7
      @blockage = false
      find_blockage(row + 1, col + 2)
    end

  end

end
