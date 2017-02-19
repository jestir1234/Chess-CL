require 'byebug'

class Piece

  attr_accessor :color, :pos, :type, :board


  def initialize(color, piece, pos, board)
    @color = color
    @pos = pos
    @type = nil
    @board = board
    find_piece(piece)
  end

  def find_piece(piece)
    case piece
    when :p
      @type = Pawn.new(pos, color, board)
    when :r
      @type = Rook.new(pos, color, board)
    when :b
      @type = Bishop.new(pos, color, board)
    when :h
      @type = Horse.new(pos, color, board)
    when :q
      @type = Queen.new(pos, color, board)
    when :k
      @type = King.new(pos, color, board)
    end
  end

  def find_blockage(row, col)
    if board.empty_space?([row, col]) && @blockage == false
      valid_moves << [row, col]
    else
      blocking_piece = board.return_piece([row, col])
      first_letter_color = blocking_piece.to_s.split("")[0]
      if first_letter_color == color.split("")[0]
        @blockage = true
      elsif blockage == false && blocking_piece.to_s.split("")[1].downcase.to_sym == :k
        valid_moves << [row, col]
      elsif blockage == false
        valid_moves << [row, col]
        @blockage = true
      end
    end

  end

end

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

class Rook < Piece

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
      (row + 1).upto(7) { |r| find_blockage(r, col) }
    end

    @blockage = false
    if row > 0
      (row - 1).downto(0) { |r| find_blockage(r, col) }
    end

    @blockage = false
    if col < 7
      (col + 1).upto(7) { |c| find_blockage(row, c) }
    end

    @blockage = false
    if col > 0
      (col - 1).downto(0) { |c| find_blockage(row, c) }
    end

  end

end

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

class Queen < Piece

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
      (row + 1).upto(7) { |r| find_blockage(r, col) }
    end

    @blockage = false
    if row > 0
      (row - 1).downto(0) { |r| find_blockage(r, col) }
    end

    @blockage = false
    if col < 7
      (col + 1).upto(7) { |c| find_blockage(row, c) }
    end

    @blockage = false
    if col > 0
      (col - 1).downto(0) { |c| find_blockage(row, c) }
    end

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
