

class Pawn < Piece

  attr_accessor :pos, :valid_moves, :color, :blockage

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

    attacks = []

    if self.color == "white"
      if row == 1
        @blockage = false
        pawn_blockage(row + 1, col) if row + 1 <= 7
        pawn_blockage(row + 2, col) if row + 2 <= 7
      else
        @blockage = false
        pawn_blockage(row + 1, col) if row + 1 <= 7
      end
      if row + 1 <= 7 && col + 1 <= 7
        attacks << [row + 1, col + 1]
      end
      if row + 1 <= 7 && col - 1 >= 0
        attacks << [row + 1, col - 1]
      end
    elsif self.color == "black"
      if row == 6
        @blockage = false
        pawn_blockage(row - 1, col) if row - 1 >= 0
        pawn_blockage(row - 2, col) if row - 2 >= 0
      else
        @blockage = false
        pawn_blockage(row - 1, col) if row - 1 >= 0
      end
      if row - 1 >= 0 && col + 1 <= 7
        attacks << [row - 1, col + 1]
      end
      if row - 1 >= 0 && col - 1 >= 0
        attacks << [row - 1, col - 1]
      end
    end

    attacks.each do |pos|
      blocking_piece = board.return_piece(pos)
      first_letter_color = blocking_piece.to_s.split("")[0]
      if !first_letter_color.nil? && first_letter_color != color.split("")[0]
        valid_moves << pos
      end
    end
  end

  def pawn_blockage(row, col)
    if board.empty_space?([row, col]) && @blockage == false
      valid_moves << [row, col]
    else
      @blockage = true
    end
  end

end
