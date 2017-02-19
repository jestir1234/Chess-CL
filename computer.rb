require_relative 'player'

class Computer < Player

  attr_accessor :board, :mode, :attacking_pos, :checked, :enemy_check_mate, :checkmate_found, :vulnerable_piece_hash, :turn_count

  def initialize(color, mode = "easy")
    @color = color
    @mode = mode
    @intersection = []
    @checked = false
    @enemy_check_mate = {check_mate_piece: nil, check_mate_start: nil, check_mate_move: nil}
    @checkmate_found = false
    @vulnerable_piece_hash = {}
    @turn_count = 0
  end

  def get_piece
    get_board
    @checkmate_found = true if check_mate_exists?
    #find all positions of pieces
    all_positions = board.all_positions(color.split("")[0])
    #find all pieces with valid moves
    if mode == "easy"
      valid_pieces = pieces_with_valid_moves(all_positions).uniq
    elsif checked == false
      return enemy_check_mate[:check_mate_piece] if @checkmate_found
      regular_piece = get_attacking_pieces(all_positions)
      vulnerable_piece = @vulnerable_piece_hash[:vulnerable_piece]
      if @attacking_pos.nil?
        return vulnerable_piece.nil? ? regular_piece : vulnerable_piece
      else
        return regular_piece
      end
    else
      valid_pieces = pieces_with_valid_moves(all_positions).uniq
    end
    #select random piece type with valid moves
    random_piece = select_random(valid_pieces)
    return random_piece.to_s.split("")[1].downcase.to_sym
  end

  def get_start_computer(piece, board)
    piece = (game.assign_piece_color(self, piece).split("")[0] + game.assign_piece_color(self, piece).split("")[1].upcase).to_sym
    #find all positions containing random piece type
    positions_of_piece = get_all_positions_of_piece(piece, color)
    #find safe starts
    safe_starts = get_safe_starts(positions_of_piece)
    #select random position of piece type
    if mode == "easy"
      random_position = positions_of_piece[rand(0..(positions_of_piece.length - 1))]
    elsif checked == false
      return enemy_check_mate[:check_mate_start] if @checkmate_found
      if @attacking_pos.nil?
        if @vulnerable_piece_hash[:vulnerable_piece_pos].nil?
          return safe_starts.empty? ? select_random(positions_of_piece) : select_random(safe_starts)
        else
          return @vulnerable_piece_hash[:vulnerable_piece_pos]
        end
      else
        get_start_hard(piece)
      end
    else
      return safe_starts.empty? ? select_random(positions_of_piece) : select_random(safe_starts)
    end
  end

  def get_move(valid_moves)
    if checked == false
      return enemy_check_mate[:check_mate_move] if @checkmate_found
      if @attacking_pos.nil?
        if @vulnerable_piece_hash[:vulnerable_piece_move].nil?
          if @safe_moves.empty?
            return select_random(valid_moves)
          else
            intersection = @safe_moves & valid_moves
            if probability <= 85
              return select_random(intersection)
            else
              return select_random(valid_moves)
            end
          end
        else
          return @vulnerable_piece_hash[:vulnerable_piece_move]
        end
      else
        return @attacking_pos
      end
    else
      select_random(valid_moves)
    end
  end

  def get_all_positions_of_piece(random_piece, color)
    board.return_piece_positions(random_piece, color)
  end

  def select_random(valid_pieces)
    valid_pieces[rand(0..(valid_pieces.length - 1))]
  end

  def pieces_with_valid_moves(all_positions)
    pieces = []
    all_positions.each do |move|
      if !valid_move(color, board.return_piece(move)[1].downcase.to_sym, move, board).empty?
        pieces << board.return_piece(move)
      end
    end
    pieces
  end

# Computer iterates through all valid moves and determines if any of those moves will result in
# enemy checkmate. If such a move exists, computer will execute the move with respective piece.
  def check_mate_exists?
    all_positions = board.all_positions(color.split("")[0])
    valid_pieces = pieces_with_valid_moves(all_positions).uniq
    piece_positions = valid_pieces.map {|piece| board.return_piece_positions(piece, color)}.flatten(1)

    if !determine_if_checkmate(piece_positions).nil?
      return true
    end
  end

# Computer iterates through possible moves and determines if any move can result in opponent's checkmate
# selects that move if it exists
  def determine_if_checkmate(piece_positions)
    game.current_player.color == "white" ? current_claimed_pieces = game.claimed_black_pieces.count : current_claimed_pieces = game.claimed_white_pieces.count

    piece_positions.each do |piece_position|
      piece = board.return_piece(piece_position)
      piece_input = (piece.to_s.split("")[0] + piece.to_s.split("")[1].downcase).to_sym
      piece_sym = piece.to_s.split("")[1].downcase.to_sym
      piece_moves = valid_move(color, piece_sym, piece_position, board)
      piece_moves.each do |move|
        board.place_move(piece_input, move, game)
        board.erase_piece(piece_position)
        game.current_player.color == "white" ? new_claimed_pieces = game.claimed_black_pieces : new_claimed_pieces = game.claimed_white_pieces
        game.switch_players
        if game.check_mate?
          game.switch_players
          game.reverse_move(game.current_player.color, current_claimed_pieces, new_claimed_pieces, move)
          board.place_move(piece_input, piece_position, self)
          set_check_mate(piece_sym, piece_position, move)
          return move
        else
          game.switch_players
          game.reverse_move(game.current_player.color, current_claimed_pieces, new_claimed_pieces, move)
          board.place_move(piece_input, piece_position, self)
        end
      end
    end
    nil
  end

  def set_check_mate(piece, start, move)
    @enemy_check_mate[:check_mate_piece] = piece
    @enemy_check_mate[:check_mate_start] = start
    @enemy_check_mate[:check_mate_move] = move
  end

# Computer finds all pieces with valid moves which share positions with enemy player piece positions
# Computer determines the enemy pieces at those positions and chooses the position of the piece with the highest value
# If pieces are tied in value then computer randomly chooses between the tied pieces.

  def get_attacking_pieces(all_positions)
    color == "white" ? enemy_color_sym = "b" : enemy_color_sym = "w"
    valid_pieces = pieces_with_valid_moves(all_positions).uniq

    piece_positions = valid_pieces.map {|piece| board.return_piece_positions(piece, color)}.flatten(1)
    possible_moves = piece_positions.map { |pos| valid_move(color, board.return_piece(pos).to_s.split("")[1].downcase.to_sym, pos, board)}.flatten(1)
    enemy_positions = board.all_positions(enemy_color_sym)

    get_safe_random_moves
    pieces_in_danger

    @attacking_pos = nil
    intersection = possible_moves & enemy_positions

    if intersection.empty?
      if !@safe_moves.empty?
        safe_pieces = pieces_with_safe_moves(piece_positions)
        return select_random(safe_pieces)
      else
        return select_random(valid_pieces).to_s.split("")[1].downcase.to_sym
      end
    else
      @attacking_pos = choose_valuable_piece(intersection)
      piece_positions.each do |pos|
        this_piece = board.return_piece(pos).to_s.split("")[1].downcase.to_sym
        moves = valid_move(color, this_piece, pos, board)
        if moves.include?(attacking_pos)
          if safe_move?(pos, attacking_pos, this_piece)
            print "This piece is #{this_piece}"
            return this_piece
          else
            @attacking_pos = nil
            if !@safe_moves.empty?
              safe_pieces = pieces_with_safe_moves(piece_positions)
              return select_random(safe_pieces)
            else
              return select_random(valid_pieces).to_s.split("")[1].downcase.to_sym
            end
          end
        end
      end
    end
  end


# Computer identifies pieces that can be taken by opponent and stores the most valuable piece
# in instance hash @vulnerable_piece_hash to potentially save instead of making a random safe move.
  def pieces_in_danger
    all_positions = board.all_positions(self.color.split("")[0])
    valid_pieces = pieces_with_valid_moves(all_positions).uniq
    piece_positions = valid_pieces.map {|piece| board.return_piece_positions(piece, color)}.flatten(1)
    enemy_moves = get_all_moves(game.enemy_color(self.color))
    intersection = piece_positions & enemy_moves

    if !intersection.empty?
      most_valuable_piece_pos = choose_valuable_piece(intersection)
      most_valuable_piece = board.return_piece(most_valuable_piece_pos).to_s.split("")[1].downcase.to_sym
      valid_moves = valid_move(self.color, most_valuable_piece, most_valuable_piece_pos, board)
      safe_move_intersection = @safe_moves & valid_moves

      if !valid_moves.empty? && most_valuable_piece != :p
        safe_move_intersection.empty? ? most_valuable_piece_move = select_random(valid_moves) : most_valuable_piece_move = select_random(safe_move_intersection)
        if safe_move?(most_valuable_piece_pos, most_valuable_piece_move, most_valuable_piece)
          @vulnerable_piece_hash[:vulnerable_piece_pos] = most_valuable_piece_pos
          @vulnerable_piece_hash[:vulnerable_piece] = most_valuable_piece
          @vulnerable_piece_hash[:vulnerable_piece_move] = most_valuable_piece_move
        end
      else
        @vulnerable_piece_hash[:vulnerable_piece_pos] = nil
        @vulnerable_piece_hash[:vulnerable_piece] = nil
        @vulnerable_piece_hash[:vulnerable_piece_move] = nil
      end
    else
      @vulnerable_piece_hash[:vulnerable_piece_pos] = nil
      @vulnerable_piece_hash[:vulnerable_piece] = nil
      @vulnerable_piece_hash[:vulnerable_piece_move] = nil
    end
  end

  def get_safe_starts(positions_of_piece)
    starts = []
    positions_of_piece.each do |pos|
      this_piece = board.return_piece(pos).to_s.split("")[1].downcase.to_sym
      moves = valid_move(color, this_piece, pos, board)
      intersection = @safe_moves & moves
      starts << pos if !intersection.empty?
    end
    starts
  end


  def pieces_with_safe_moves(piece_positions)
    safe_pieces = []
    piece_positions.each do |pos|
      this_piece = board.return_piece(pos).to_s.split("")[1].downcase.to_sym
      moves = valid_move(color, this_piece, pos, board)
      intersection = @safe_moves & moves
      safe_pieces << this_piece if !intersection.empty?
    end
    safe_pieces
  end


  def safe_move?(pos, attacking_pos, piece)
    piece = (game.assign_piece_color(game.current_player, piece.to_s)).to_sym
    profitable_move = false
    #Piece trade off worth attack?
    profitable_move = true if attack_worth_it?(piece, attacking_pos, pos)

    #testing move placement
    game.current_player.color == "white" ? current_claimed_pieces = game.claimed_black_pieces.count : current_claimed_pieces = game.claimed_white_pieces.count
    board.place_move(piece, attacking_pos, game)
    board.erase_piece(pos)
    game.current_player.color == "white" ? new_claimed_pieces = game.claimed_black_pieces : new_claimed_pieces = game.claimed_white_pieces

    king_pos = board.return_king(color)

    #will my king be checked?
    if game.check_status(king_pos, color)
      game.reverse_move(game.current_player.color, current_claimed_pieces, new_claimed_pieces, attacking_pos)
      board.place_move(piece, pos, game)
      return true if profitable_move
    else
      game.reverse_move(game.current_player.color, current_claimed_pieces, new_claimed_pieces, attacking_pos)
      board.place_move(piece, pos, game)
      return false
    end

  end

# Computer weighs value of piece being taken and identifies whether an enemy counter attack exists
# If a counter exists, the computer determines whether the piece captured is worth more than the piece sacrificed.
  def attack_worth_it?(piece, attacking_pos, pos)
    enemy_piece = board.return_piece(attacking_pos)
    my_piece_value = board.return_piece_value(piece.to_s.split("")[1].to_sym)
    enemy_piece.nil? ? enemy_piece_value = 10 : enemy_piece_value = board.return_piece_value(enemy_piece.to_s.split("")[1].downcase.to_sym)

    #testing move placement
    game.current_player.color == "white" ? current_claimed_pieces = game.claimed_black_pieces.count : current_claimed_pieces = game.claimed_white_pieces.count
    board.place_move(piece, attacking_pos, game)
    board.erase_piece(pos)
    game.current_player.color == "white" ? new_claimed_pieces = game.claimed_black_pieces : new_claimed_pieces = game.claimed_white_pieces

    enemy_moves = get_all_moves(game.enemy_color(color))

    if enemy_counter?(enemy_moves, attacking_pos)
      if my_piece_value <= enemy_piece_value
        game.reverse_move(game.current_player.color, current_claimed_pieces, new_claimed_pieces, attacking_pos)
        board.place_move(piece, pos, game)
        return true
      else
        game.reverse_move(game.current_player.color, current_claimed_pieces, new_claimed_pieces, attacking_pos)
        board.place_move(piece, pos, game)
        return false
      end
    else
      game.reverse_move(game.current_player.color, current_claimed_pieces, new_claimed_pieces, attacking_pos)
      board.place_move(piece, pos, game)
      return true
    end

  end

  def enemy_counter?(enemy_moves, attacking_pos)
    return true if enemy_moves.include?(attacking_pos)
  end

  def choose_valuable_piece(intersection)
    most_valuable_piece_value = 0
    most_valuable_piece_pos = nil

    intersection.each do |pos|
      piece = board.return_piece(pos).to_s.split("")[1].downcase.to_sym
      piece_value = board.return_piece_value(piece)
      if piece_value > most_valuable_piece_value
        most_valuable_piece_pos = pos
        most_valuable_piece_value = piece_value
      elsif piece_value == most_valuable_piece_value
        flip = flip_coin
        if flip > 0
          most_valuable_piece_pos = pos
          most_valuable_piece_value = piece_value
        end
      end
    end
    most_valuable_piece_pos
  end

  def flip_coin
    rand(0..1)
  end

  def probability
    rand(1..100)
  end

  def get_start_hard(piece)
    piece_positions = board.return_piece_positions(piece, color)
    piece_positions.each do |pos|
      moves = valid_move(color, board.return_piece(pos).to_s.split("")[1].downcase.to_sym, pos, board)
      return pos if moves.include?(attacking_pos)
    end
  end

  #upgrade pawn to queen because...why choose any other piece?
  def upgrade_pawn
    return "q"
  end

end
