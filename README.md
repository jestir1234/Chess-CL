# About
Command-line based chess game built with ruby.
 - Player vs Player with interactive prompts to input pieces and moves.
 - Simple computer AI with the ability to judge piece exchange, find current check-mate moves, identify vulnerable pieces, and compare enemy piece values.


# Demo
( run game.rb in console )
- Input 1 in first prompt to play against computer, 2 to initiate a game with two players, or 0 to watch two computers play against each other.
- Answer y/n to the prompt asking whether you want to display the piece images.

```shell
How many human players?
1
Would you like to display the piece images? (y/n)
y
"     0    1    2    3    4    5    6    7"
"-------------------------------------------"
"0 | ♜  | ♞  | ♝  | ♛  | ♚  | ♝  | ♞  | ♜  |"
"-------------------------------------------"
"1 | ♟  | ♟  | ♟  | ♟  | ♟  | ♟  | ♟  | ♟  |"
"-------------------------------------------"
"2 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"3 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"4 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"5 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"6 | ♙  | ♙  | ♙  | ♙  | ♙  | ♙  | ♙  | ♙  |"
"-------------------------------------------"
"7 | ♖  | ♘  | ♗  | ♕  | ♔  | ♗  | ♘  | ♖  |"
"-------------------------------------------"

---------------------------
      Captured Pieces
---------------------------
WHITE: 
BLACK: 


WHITE player's turn.
This is turn 1 for player white.
Select your piece. (ex: 'h' for horse, 'k' for king, q, r, b, p)
h
Type the starting position of this piece. (ex: '3,4', '5,6')
0,1
Your valid moves:
[2, 0][2, 2]

Place your move. (ex: '3,4', '5,6')
2,2
WHITE moves Horse from [0, 1] to [2, 2]!
"     0    1    2    3    4    5    6    7"
"-------------------------------------------"
"0 | ♜  |    | ♝  | ♛  | ♚  | ♝  | ♞  | ♜  |"
"-------------------------------------------"
"1 | ♟  | ♟  | ♟  | ♟  | ♟  | ♟  | ♟  | ♟  |"
"-------------------------------------------"
"2 |    |    | ♞  |    |    |    |    |    |"
"-------------------------------------------"
"3 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"4 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"5 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"6 | ♙  | ♙  | ♙  | ♙  | ♙  | ♙  | ♙  | ♙  |"
"-------------------------------------------"
"7 | ♖  | ♘  | ♗  | ♕  | ♔  | ♗  | ♘  | ♖  |"
"-------------------------------------------"

---------------------------
      Captured Pieces
---------------------------
WHITE: 
BLACK: 


BLACK player's turn.
This is turn 1 for player black.
BLACK moves Pawn from [6, 0] to [5, 0]!
"     0    1    2    3    4    5    6    7"
"-------------------------------------------"
"0 | ♜  |    | ♝  | ♛  | ♚  | ♝  | ♞  | ♜  |"
"-------------------------------------------"
"1 | ♟  | ♟  | ♟  | ♟  | ♟  | ♟  | ♟  | ♟  |"
"-------------------------------------------"
"2 |    |    | ♞  |    |    |    |    |    |"
"-------------------------------------------"
"3 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"4 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"5 | ♙  |    |    |    |    |    |    |    |"
"-------------------------------------------"
"6 |    | ♙  | ♙  | ♙  | ♙  | ♙  | ♙  | ♙  |"
"-------------------------------------------"
"7 | ♖  | ♘  | ♗  | ♕  | ♔  | ♗  | ♘  | ♖  |"
"-------------------------------------------"

---------------------------
      Captured Pieces
---------------------------
WHITE: 
BLACK: 


WHITE player's turn.
This is turn 2 for player white.
Select your piece. (ex: 'h' for horse, 'k' for king, q, r, b, p)
```
