require 'colorize'

class Board

  PIECE_IMAGE = {
    wP: "\u{265F}",
    wR: "\u{265C}",
    wH: "\u{265E}",
    wB: "\u{265D}",
    wQ: "\u{265B}",
    wK: "\u{265A}",
    bP: "\u{2659}",
    bR: "\u{2656}",
    bH: "\u{2658}",
    bB: "\u{2657}",
    bQ: "\u{2655}",
    bK: "\u{2654}"
  }

  WHITE_PIECES = {
    wp: "Pawn",
    wr: "Rook",
    wh: "Horse",
    wb: "Bishop",
    wq: "Queen",
    wk: "King"
  }

  BLACK_PIECES = {
    bp: "Pawn",
    br: "Rook",
    bh: "Horse",
    bb: "Bishop",
    bq: "Queen",
    bk: "King"
  }

  PIECE_VALUE = {
    p: 1,
    h: 2,
    b: 2,
    r: 3,
    q: 4,
    k: 5
  }

  def self.default_board
    Array.new(8) { Array.new (8)}
  end

  attr_accessor :grid, :piece_images, :cursor

  def initialize(grid = Board.default_board, piece_images = false)
    @grid = grid
    white_player = "w"
    black_player = "b"
    set_pieces
    @piece_images = piece_images
  end

  def set_cursor(cursor)
    @cursor = cursor
  end

  def get_piece(pos)
    row, col = pos
    grid[row][col]
  end

  def all_positions(color)
    result = []
    (0..7).each do |row|
      (0..7).each do |col|
        piece = grid[row][col]
        color_of_piece = piece.to_s.split("")[0]
        if color_of_piece == color
          result << [row, col]
        end
      end
    end
    result
  end

  def return_piece_value(piece)
    PIECE_VALUE[piece]
  end

  def return_piece_name(piece, color)
    color == "white" ? WHITE_PIECES[piece] : BLACK_PIECES[piece]
  end

  def return_piece_positions(piece, color)
    self.all_positions(color.split("")[0]).map {|pos| pos if return_piece(pos) == piece}.compact
  end

  def return_piece(pos)
    row = pos[0]
    col = pos[1]
    grid[row][col]
  end

  def return_king(color)
    color == "white" ? color_sym = "w" : color_sym = "b"
    (0..7).each do |row|
      (0..7).each do |col|
        piece = return_piece([row, col])
        if piece.to_s.split("")[1] == "K"
          if piece.to_s.split("")[0] == color_sym
            return [row, col]
          end
        end
      end
    end
  end

  def valid_piece?(pos, piece, color)
    color == "white" ? color_sym = :w : color_sym = :b
    row = pos[0]
    col = pos[1]
    return false if grid[row][col].nil?
    piece_at_pos = grid[row][col].to_s.split("")[1].downcase.to_sym
    player_color = grid[row][col].to_s.split("")[0].to_sym

    return true if piece_at_pos == piece && player_color == color_sym
  end

  def empty_space?(pos)
    row = pos[0]
    col = pos[1]
    return true if grid[row][col].nil?
  end

  def valid_pos?(pos)
   pos.all? { |coord| coord.between?(0, 7) }
 end

  def place_move(piece, pos, game)
    row = pos[0]
    col = pos[1]

    if WHITE_PIECES.keys.include?(piece)
      piece = piece.to_s.split("")[1].upcase
      if !grid[row][col].nil?
        game.take_piece(grid[row][col], "black")
      end
      grid[row][col] = ("w" + piece).to_sym
    elsif BLACK_PIECES.keys.include?(piece)
      piece = piece.to_s.split("")[1].upcase
      if !grid[row][col].nil?
        game.take_piece(grid[row][col], "white")
      end
      grid[row][col] = ("b" + piece).to_sym
    else
      raise "Invalid piece"
    end
  end

  def erase_piece(pos)
    row = pos[0]
    col = pos[1]
    grid[row][col] = nil
  end

  def blank_board
    (0..7).each do |row|
      (0..7).each do |col|
        grid[row][col] = nil
      end
    end
  end

  def display_grid
    header = (0...grid.length).to_a.join("    ")
    puts "    #{header}"
    puts "-------------------------------------------"
    (0...grid.length).each_with_index do |x, i|
      puts "#{x} " + display_row(x) + " |"
      puts "-------------------------------------------"
    end
  end

  def display_row(x)
    result = []
    if @cursor
      cursor = [@cursor.cursor_pos[0], @cursor.cursor_pos[1]]
    end

    if @piece_images
      (1..grid.length).each_with_index do |el, i|
        if grid[x][i].nil?
          if cursor == [x, i]
            result << "|" << "  ".colorize(background: :blue)
          else
            result << "|   "
          end
        else
          if cursor == [x, i]
            result << "|" << PIECE_IMAGE[grid[x][i]].colorize(:blue) << ""
          else
            result << "|" << PIECE_IMAGE[grid[x][i]] << ""
          end
        end
      end
    else
      (1..grid.length).each_with_index do |el, i|
        if grid[x][i].nil?
          if cursor == [x, i]
            result << "|   ".colorize(:blue)
          else
            result << "|   "
          end
        else
          if cursor == [x, i]
            result << "|" << grid[x][i].colorize(:blue)
          else
            result << "|"
          end
        end
      end
    end
    result.join(" ")
  end

  def set_pieces
    set_white
    set_black
  end

  def set_white
    #pawns
    0.upto(7) { |col| grid[1][col] = :wP }
    #rooks
    grid[0][0] = :wR
    grid[0][7] = :wR
    #horses
    grid[0][1] = :wH
    grid[0][6] = :wH
    #bishops
    grid[0][2] = :wB
    grid[0][5] = :wB
    #queen
    grid[0][3] = :wQ
    #king
    grid[0][4] = :wK
  end

  def set_black
    #pawns
    0.upto(7) { |col| grid[6][col] = :bP }
    #rooks
    grid[7][0] = :bR
    grid[7][7] = :bR
    #horses
    grid[7][1] = :bH
    grid[7][6] = :bH
    #bishops
    grid[7][2] = :bB
    grid[7][5] = :bB
    #queen
    grid[7][4] = :bK
    #king
    grid[7][3] = :bQ
  end

  def only_kings_left?
    result = []
    (0..7).each do |row|
      (0..7).each do |col|
        piece = grid[row][col]
        if piece != nil && piece.to_s.split("")[1].downcase.to_sym != :k
          result << piece
        end
      end
    end
    return true if result.empty?
  end

end
