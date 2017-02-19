# About
Command-line based chess game built with ruby.
 - Player vs Player with interactive prompts to input pieces and moves.
 - Simple computer AI with the ability to judge piece exchange, find current check-mate moves, identify vulnerable pieces, and compare enemy piece values.


# Demo
( run game.rb in console )
- Input 1 in first prompt to play against computer, 2 to initiate a game with two players, or 0 to watch two computers play against each other.

```shell
How many human players?
1
"     0    1    2    3    4    5    6    7"
"-------------------------------------------"
"0 | wR | wH | wB | wQ | wK | wB | wH | wR |"
"-------------------------------------------"
"1 | wP | wP | wP | wP | wP | wP | wP | wP |"
"-------------------------------------------"
"2 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"3 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"4 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"5 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"6 | bP | bP | bP | bP | bP | bP | bP | bP |"
"-------------------------------------------"
"7 | bR | bH | bB | bQ | bK | bB | bH | bR |"
"-------------------------------------------"

---------------------------
      Captured Pieces
---------------------------
WHITE: 
BLACK: 


WHITE player's turn.
Select your piece. (ex: 'h' for horse, 'k' for king, q, r, b, p)
p
Type the starting position of this piece. (ex: '3,4', '5,6')
1,1
Your valid moves:
[2, 1][3, 1]

Place your move. (ex: '3,4', '5,6')
3,1
WHITE moves Pawn from [1, 1] to [3, 1]!
"     0    1    2    3    4    5    6    7"
"-------------------------------------------"
"0 | wR | wH | wB | wQ | wK | wB | wH | wR |"
"-------------------------------------------"
"1 | wP |    | wP | wP | wP | wP | wP | wP |"
"-------------------------------------------"
"2 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"3 |    | wP |    |    |    |    |    |    |"
"-------------------------------------------"
"4 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"5 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"6 | bP | bP | bP | bP | bP | bP | bP | bP |"
"-------------------------------------------"
"7 | bR | bH | bB | bQ | bK | bB | bH | bR |"
"-------------------------------------------"

---------------------------
      Captured Pieces
---------------------------
WHITE: 
BLACK: 


BLACK player's turn.
BLACK moves Pawn from [6, 0] to [5, 0]!
"     0    1    2    3    4    5    6    7"
"-------------------------------------------"
"0 | wR | wH | wB | wQ | wK | wB | wH | wR |"
"-------------------------------------------"
"1 | wP |    | wP | wP | wP | wP | wP | wP |"
"-------------------------------------------"
"2 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"3 |    | wP |    |    |    |    |    |    |"
"-------------------------------------------"
"4 |    |    |    |    |    |    |    |    |"
"-------------------------------------------"
"5 | bP |    |    |    |    |    |    |    |"
"-------------------------------------------"
"6 |    | bP | bP | bP | bP | bP | bP | bP |"
"-------------------------------------------"
"7 | bR | bH | bB | bQ | bK | bB | bH | bR |"
"-------------------------------------------"

---------------------------
      Captured Pieces
---------------------------
WHITE: 
BLACK: 


WHITE player's turn.
Select your piece. (ex: 'h' for horse, 'k' for king, q, r, b, p)
```
