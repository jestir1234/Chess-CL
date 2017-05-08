class King < Piece
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

    #up + diag
    if row - 1 >= 0
      @blockage = false
      find_blockage(row - 1, col)
    end
    if row - 1 >= 0 && col + 1 <= 7
      @blockage = false
      find_blockage(row - 1, col + 1)
    end
    if row - 1 >= 0 && col - 1 >= 0
      @blockage = false
      find_blockage(row - 1, col - 1)
    end

    #down + diag
    if row + 1 <= 7
      @blockage = false
      find_blockage(row + 1, col)
    end
    if row + 1 <= 7 && col + 1 <= 7
      @blockage = false
      find_blockage(row + 1, col + 1)
    end
    if row + 1 <= 7 && col - 1 >= 0
      @blockage = false
      find_blockage(row + 1, col - 1)
    end

    #left
    if col - 1 >= 0
      @blockage = false
      find_blockage(row, col - 1)
    end

    #right
    if col + 1 <= 7
      @blockage = false
      find_blockage(row, col + 1)
    end

  end

end
