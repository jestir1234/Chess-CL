class Bishop < Piece

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

    @blockage = false
    if row < 7
      i = 1
      (row + 1).upto(7) do |r|
        if (col + i) <= 7
          find_blockage(r, col + i)
          i += 1
        end
      end
    end

    @blockage = false
    if row > 0
      i = 1
      (row - 1).downto(0) do |r|
        if (col + i) <= 7
          find_blockage(r, col + i)
          i += 1
        end
      end
    end

    @blockage = false
    if row < 7
      i = 1
      (row + 1).upto(7) do |r|
        if (col - i) >= 0
          find_blockage(r, col - i)
          i += 1
        end
      end
    end

    @blockage = false
    if row > 0
      i = 1
      (row - 1).downto(0) do |r|
        if (col - i) >= 0
          find_blockage(r, col - i)
          i += 1
        end
      end
    end

  end

end
