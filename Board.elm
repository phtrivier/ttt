module TTT (..) where

type Cell
  = X
  | O
  | N


cellValue : Cell -> Int
cellValue cell =
  case cell of
    X ->
      1

    O ->
      -1

    N ->
      0

type alias Board

emptyBoard : 

