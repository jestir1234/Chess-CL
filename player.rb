require_relative 'piece'
require_relative 'board'
require 'byebug'

class Player

  attr_accessor :name, :color, :game, :checked

  PIECES = [:k, :q, :p, :r, :h, :b, :p]

  def initialize(color)
    @color = color
    @checked = false
  end

  def get_game(game)
    @game = game
  end

  def display_valid_moves(valid_moves)
    puts "Your valid moves:"
    valid_moves.each { |move| print move }
    print "\n"
    print "\n"
  end

  def get_move(valid_moves)
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

  def upgrade_pawn
    puts "What piece do you want? (ex: 'q' for queen, 'h' for horse...etc)"
    input = gets.chomp
  end
end
