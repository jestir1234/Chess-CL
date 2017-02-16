require_relative 'player'

class Computer < Player

  attr_accessor :board, :mode, :attacking_pos, :checked, :enemy_check_mate, :checkmate_found

  def initialize(color, mode = "easy")
    @color = color
    @mode = mode
    @intersection = []
    @checked = false
    @enemy_check_mate = {check_mate_piece: nil, check_mate_start: nil, check_mate_move: nil}
    @checkmate_found = false
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
      return get_attacking_pieces(all_positions)
    else
      valid_pieces = pieces_with_valid_moves(all_positions).uniq
    end
    #select random piece type with valid moves
    random_piece = select_random_piece(valid_pieces)
    return random_piece.to_s.split("")[1].downcase.to_sym
  end

  def get_start_computer(piece, board)
    piece = (game.assign_piece_color(self, piece).split("")[0] + game.assign_piece_color(self, piece).split("")[1].upcase).to_sym
    #find all positions containing random piece type
    positions_of_piece = get_all_positions_of_piece(piece, color)
    #select random position of piece type
    if mode == "easy"
      random_position = positions_of_piece[rand(0..(positions_of_piece.length - 1))]
    elsif checked == false
      return enemy_check_mate[:check_mate_start] if @checkmate_found
      attacking_pos.nil? ? positions_of_piece[rand(0..(positions_of_piece.length - 1))] : get_start_hard(piece)
    else
      random_position = positions_of_piece[rand(0..(positions_of_piece.length - 1))]
    end
  end

  def get_move(valid_moves)

    if checked == false
      return enemy_check_mate[:check_mate_move] if @checkmate_found
      attacking_pos.nil? ? valid_moves[rand(0..(valid_moves.length - 1))] : attacking_pos
    else
      valid_moves[rand(0..(valid_moves.length - 1))]
    end
  end

  def get_all_positions_of_piece(random_piece, color)
    board.return_piece_positions(random_piece, color)
  end

  def select_random_piece(valid_pieces)
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

  def get_all_moves(color)
    all_positions = board.all_positions(color.split("")[0])
    moves = []
    all_positions.each do |pos|
      moves << valid_move(color, board.return_piece(pos).to_s.split("")[1].downcase.to_sym, pos, board)
    end
    moves.flatten(1)
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

    @attacking_pos = nil
    intersection = possible_moves & enemy_positions
    if intersection.empty?
      valid_pieces[rand(0..(valid_pieces.length - 1))].to_s.split("")[1].downcase.to_sym
    else
      # @attacking_pos = intersection[rand(0..(intersection.length - 1))]
      @attacking_pos = choose_valuable_piece(intersection)
      piece_positions.each do |pos|
        this_piece = board.return_piece(pos).to_s.split("")[1].downcase.to_sym
        moves = valid_move(color, this_piece, pos, board)
        if moves.include?(attacking_pos)
          if safe_move?(pos, attacking_pos, this_piece)
            return this_piece
          else
            @attacking_pos = nil
            return valid_pieces[rand(0..(valid_pieces.length - 1))].to_s.split("")[1].downcase.to_sym
          end
        end
      end
    end
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

  def attack_worth_it?(piece, attacking_pos, pos)
    enemy_piece = board.return_piece(attacking_pos)
    my_piece_value = board.return_piece_value(piece.to_s.split("")[1].to_sym)
    enemy_piece_value = board.return_piece_value(enemy_piece.to_s.split("")[1].downcase.to_sym)

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

  def get_start_hard(piece)
    piece_positions = board.return_piece_positions(piece, color)
    piece_positions.each do |pos|
      moves = valid_move(color, board.return_piece(pos).to_s.split("")[1].downcase.to_sym, pos, board)
      return pos if moves.include?(attacking_pos)
    end
  end

  def get_board
    @board = game.assign_board(self)
  end

  #upgrade pawn
  def upgrade_pawn
    return "q"
  end

end
