require_relative 'piece'
require_relative 'board'
require 'byebug'

class Player

  attr_accessor :name, :color, :game, :checked, :safe_moves, :board, :turn_count

  PIECES = [:k, :q, :p, :r, :h, :b, :p]

  def initialize(color)
    @color = color
    @checked = false
    @safe_moves = []
    @turn_count = 0
  end

  def get_game(game)
    @game = game
  end

  def get_board
    @board = game.assign_board(self)
  end

  def display_valid_moves(valid_moves)
    puts "Your valid moves:"
    valid_moves.each { |move| print move }
    print "\n"
    print "\n"
  end

  def get_move(valid_moves)
    get_safe_random_moves
    display_valid_moves(valid_moves)

    puts "Place your move. (ex: '3,4', '5,6')"

    moves = gets.chomp
    moves = moves.split(",").map { |num| num.to_i }

    until valid_moves.include?(moves)
      puts "That is an invalid move. Place another."
      moves = gets.chomp
      moves = moves.split(",").map { |num| num.to_i }
    end
    return moves
  end

  def get_start(piece, board)
    color = self.color
    puts "Type the starting position of this piece. (ex: '3,4', '5,6')"
    start = gets.chomp
    start = start.split(",").map { |num| num.to_i }

    until valid_start?(start)
      puts "Invalid starting position. Re-enter coordinates. (ex: '3,4' , '6,5' , '7,1' )"
      start = gets.chomp
      start = start.split(",").map {|num| num.to_i}
    end

    until board.valid_piece?(start, piece, color)
      puts "Piece is missing from starting position."
      start = gets.chomp
      start = start.split(",").map { |num| num.to_i }
    end
    start
  end

  def get_piece
    get_board
    puts "Select your piece. (ex: 'h' for horse, 'k' for king, q, r, b, p)"
    piece = gets.chomp.to_sym
    until PIECES.include?(piece)
      puts "Invalid piece, choose another."
      piece = gets.chomp.to_sym
    end
    piece
  end

  def valid_move(color, piece, start, board)
    my_piece = Piece.new(color, piece, start, board)
    return my_piece.type.valid_moves
  end

  def valid_start?(start)
    return false if start.nil? || start.count != 2
    return false if !start[0].is_a?(Integer) || !start[1].is_a?(Integer)
    true
  end

  def get_all_moves(color)
    all_positions = board.all_positions(color.split("")[0])
    moves = []
    all_positions.each do |pos|
      moves << valid_move(color, board.return_piece(pos).to_s.split("")[1].downcase.to_sym, pos, board)
    end
    moves.flatten(1)
  end

  def get_safe_random_moves
    all_moves = get_all_moves(color)
    enemy_moves = get_all_moves(game.enemy_color(color))
    pawn_attacks = find_enemy_pawn_attacks
    pawn_moves = find_nonattacking_enemy_pawn_moves
    intersection = pawn_moves & all_moves
    intersection = intersection - enemy_moves

    non_matches = all_moves.reject {|move| enemy_moves.include?(move)}

    intersection.each {|move| non_matches << move}
    @safe_moves = non_matches.reject {|move| pawn_attacks.include?(move)}
  end

  def upgrade_pawn
    puts "What piece do you want? (ex: 'q' for queen, 'h' for horse...etc)"
    input = gets.chomp
  end

  def find_enemy_pawn_attacks
    self.color == "black" ? enemy_pawn_positions = board.return_piece_positions(:wP, "white") : enemy_pawn_positions = board.return_piece_positions(:bP, "black")
    pawn_attacks = []
    enemy_pawn_positions.each do |pos|
      row = pos[0]
      col = pos[1]
      if self.color == "black"
        if col + 1 <= 7
          pawn_attacks << [row + 1, col + 1]
        end
        if col - 1 >= 0
          pawn_attacks << [row + 1, col - 1]
        end
      else
        if col + 1 <= 7
          pawn_attacks << [row - 1, col + 1]
        end
        if col - 1 >= 0
          pawn_attacks << [row - 1, col - 1]
        end
      end
    end
    pawn_attacks
  end

  def find_nonattacking_enemy_pawn_moves
      self.color == "black" ? enemy_pawn_positions = board.return_piece_positions(:wP, "white") : enemy_pawn_positions = board.return_piece_positions(:bP, "black")
      pawn_moves = []
      enemy_pawn_positions.each do |pos|
        row = pos[0]
        col = pos[1]
        if self.color == "black"
          if row == 1
            pawn_moves << [row + 1, col]
            pawn_moves << [row + 2, col]
          else
            pawn_moves << [row + 1, col]
          end
        else
          if row == 6
            pawn_moves << [row - 1, col]
            pawn_moves << [row - 2, col]
          else
            pawn_moves << [row - 1, col]
          end
        end
      end
      pawn_moves
  end

end
