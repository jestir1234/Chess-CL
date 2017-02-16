require 'byebug'
require_relative 'board'
require_relative 'player'
require_relative 'computer'

class Game

  attr_accessor :white_player, :black_player, :current_player, :board, :claimed_white_pieces, :claimed_black_pieces, :game_over

  def initialize(board = Board.new, player1 = Player.new("white"), player2 = Player.new("black"))
    @white_player = player1
    @black_player = player2
    @current_player = @white_player
    @board = board
    @claimed_white_pieces = []
    @claimed_black_pieces = []
    @game_over = false
  end

  def play

    until game_over
      board.display_grid
      display_captured_pieces
      puts "#{@current_player.color.upcase} player's turn."
      player_move
    end

    board.display_grid
    puts "#{assign_winner.color.upcase} player has won the game!"

  end

  def player_move
    assign_game
    king_pos = board.return_king(@current_player.color)
    @current_player.checked = false

    if check_status(king_pos, @current_player.color) == false
      puts "#{@current_player.color}'s king is checked!"
      @current_player.checked = true
    end

    check_mate?

    if @game_over == false
      valid_moves = []
      until !valid_moves.empty?
        piece = @current_player.get_piece
        @current_player.class == Player ? start = @current_player.get_start(piece, board) : start = @current_player.get_start_computer(piece, board)
        valid_moves = @current_player.valid_move(@current_player.color, piece, start, board)
        puts "You can't move that piece right now!" if valid_moves.empty?
      end
      move = @current_player.get_move(valid_moves)

      piece = assign_piece_color(@current_player, piece).to_sym

      @current_player.color == "white" ? current_claimed_pieces = @claimed_black_pieces.count : current_claimed_pieces = @claimed_white_pieces.count
      board.place_move(piece, move, self)
      board.erase_piece(start)
      @current_player.color == "white" ? new_claimed_pieces = @claimed_black_pieces : new_claimed_pieces = @claimed_white_pieces

      king_pos = board.return_king(@current_player.color)


      if check_status(king_pos, @current_player.color)
        piece_name = board.return_piece_name(piece.to_sym, @current_player.color)
        puts "#{@current_player.color.upcase} moves #{piece_name} from #{start} to #{move}!"
        if piece_taken?(current_claimed_pieces, new_claimed_pieces)
          taken_piece = board.return_piece_name(downcase_piece(last_taken_piece(@current_player.color)), enemy_color(@current_player.color))
          puts "#{@current_player.color.upcase} takes #{enemy_color(@current_player.color)}'s #{taken_piece}!"
        end
        if piece == :wp && move[0] == 7
          new_piece = (assign_piece_color(@current_player, @current_player.upgrade_pawn)).to_sym
          piece_name = board.return_piece_name(new_piece, @current_player.color)
          board.erase_piece(move)
          board.place_move(new_piece, move, self)
          puts "#{@current_player.color} has upgraded Pawn to #{piece_name}!"
        elsif piece == :bp && move[0] == 0
          new_piece = (assign_piece_color(@current_player, @current_player.upgrade_pawn)).to_sym
          piece_name = board.return_piece_name(new_piece, @current_player.color)
          board.erase_piece(move)
          board.place_move(new_piece, move, self)
          puts "#{@current_player.color} has upgraded Pawn to #{piece_name}!"
        end
        switch_players
      else
        puts "Moving there will place your king in check!"
        reverse_move(@current_player.color, current_claimed_pieces, new_claimed_pieces, move)
        board.place_move(piece, start, self)
        self.player_move
      end
    end
  end

  def enemy_color(color)
    color == "white" ? "black" : "white"
  end

  def downcase_piece(piece)
    piece = (piece.to_s.split("")[0] + piece.to_s.split("")[1].downcase).to_sym
  end

  def piece_taken?(current_claimed_pieces, new_claimed_pieces)
    return true if current_claimed_pieces < new_claimed_pieces.count
  end

  def last_taken_piece(color)
    @current_player.color == "white" ? @claimed_black_pieces[-1] : @claimed_white_pieces[-1]
  end

  def switch_players
    @current_player == @white_player ? @current_player = @black_player : @current_player = @white_player
  end

  def assign_piece_color(current_player, piece)
    current_player.color == "white" ? "w#{piece}" : "b#{piece}"
  end

  def assign_game
    @current_player.get_game(self)
  end

  def assign_board(player)
    @board
  end

  def check_status(king_pos, color)
    color == "white" ? enemy_color = "black" : enemy_color = "white"
    enemy_positions = board.all_positions(enemy_color.split("")[0])


    enemy_positions.each do |pos|
      enemy_moves = @current_player.valid_move(enemy_color, board.return_piece(pos)[1].downcase.to_sym, pos, board)
      if enemy_moves.include?(king_pos)
        return false
      end
    end

    true
  end

  def check_mate?
    all_positions = board.all_positions(@current_player.color.split("")[0])

    all_positions.each do |pos|
      valid_moves = @current_player.valid_move(@current_player.color, board.return_piece(pos)[1].downcase.to_sym, pos, board)
      piece = (board.return_piece(pos).to_s.split("")[0] + board.return_piece(pos).to_s.split("")[1].downcase).to_sym
      piece_sym = piece.to_s.split("")[1].to_sym
      if piece_sym == :k
        return false if check_status(pos, @current_player.color)
      end
      valid_moves.each do |move|

        @current_player.color == "white" ? current_claimed_pieces = @claimed_black_pieces.count : current_claimed_pieces = @claimed_white_pieces.count
        board.place_move(piece, move, self)
        board.erase_piece(pos)
        @current_player.color == "white" ? new_claimed_pieces = @claimed_black_pieces : new_claimed_pieces = @claimed_white_pieces

        king_pos = board.return_king(@current_player.color)

        if check_status(king_pos, @current_player.color)
          reverse_move(@current_player.color, current_claimed_pieces, new_claimed_pieces, move)
          board.place_move(piece, pos, self)
          return false
        else
          reverse_move(@current_player.color, current_claimed_pieces, new_claimed_pieces, move)
          board.place_move(piece, pos, self)
        end
      end
    end
    puts "********CHECK MATE!*********"
    @game_over = true
    true

  end

  def take_piece(piece, color)
    color == "white" ? @claimed_white_pieces << piece : @claimed_black_pieces << piece
  end

  def reverse_move(color, current_claimed_pieces, new_claimed_pieces, move)
    if !new_claimed_pieces.nil? && new_claimed_pieces.count > current_claimed_pieces
      if color == "white"
        last_black_piece = (@claimed_black_pieces[-1].to_s.split("")[0] + @claimed_black_pieces[-1].to_s.split("")[1].downcase).to_sym
        board.erase_piece(move)
        board.place_move(last_black_piece, move, self)
        @claimed_black_pieces.pop
      else
        last_white_piece = (@claimed_white_pieces[-1].to_s.split("")[0] + @claimed_white_pieces[-1].to_s.split("")[1].downcase).to_sym
        board.erase_piece(move)
        board.place_move(last_white_piece, move, self)
        @claimed_white_pieces.pop
      end
    else
      board.erase_piece(move)
    end
  end

  def wipe_board
    board.blank_board
  end

  def display_captured_pieces
    puts "\n"
    puts "---------------------------"
    puts "      Captured Pieces"
    puts "---------------------------"
    white_pieces = "WHITE: "
    black_pieces = "BLACK: "

    @claimed_white_pieces.each do |piece|
      piece = downcase_piece(piece)
      black_pieces += board.return_piece_name(piece, "white") + ", "
    end
    @claimed_black_pieces.each do |piece|
      piece = downcase_piece(piece)
      white_pieces += board.return_piece_name(piece, "black") + ", "
    end
    puts "#{white_pieces}"
    puts "#{black_pieces}"
    puts "\n"
    puts "\n"
  end

  def assign_winner
    @current_player.color == "white" ? @black_player : @white_player
  end

end

if $PROGRAM_NAME == __FILE__
  puts "How many human players?"
  input = gets.chomp.to_i
  if input == 1
    board = Board.new
    player1 = Player.new("white")
    player2 = Computer.new("black", "hard")
    game = Game.new(board, player1, player2)
    game.play
  else
    game = Game.new
    game.play
  end
end
