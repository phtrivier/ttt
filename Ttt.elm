module Ttt (..) where

import Dict exposing (..)
import Result exposing (..)


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


type alias Board =
  Dict ( Int, Int ) Cell


emptyBoard : Board
emptyBoard =
  Dict.empty
    |> Dict.insert ( 0, 0 ) N
    |> Dict.insert ( 0, 1 ) N
    |> Dict.insert ( 0, 2 ) N
    |> Dict.insert ( 1, 0 ) N
    |> Dict.insert ( 1, 1 ) N
    |> Dict.insert ( 1, 2 ) N
    |> Dict.insert ( 2, 0 ) N
    |> Dict.insert ( 2, 1 ) N
    |> Dict.insert ( 2, 2 ) N


type BadMove
  = InvalidCell ( Int, Int )
  | AlreadyTaken


cellAt : ( Int, Int ) -> Board -> Maybe Cell
cellAt ( i, j ) board =
  Dict.get ( i, j ) board


move : ( Int, Int ) -> Cell -> Board -> Result BadMove Board
move ( i, j ) cell board =
  if (i < 0 || i >= 3 || j < 0 || j >= 3) then
    Err (InvalidCell ( i, j ))
  else
    case cellAt ( i, j ) board of
      Nothing ->
        Err (InvalidCell ( i, j ))

      Just N ->
        Ok (Dict.insert ( i, j ) cell board)

      Just c ->
        if (c == cell) then
          Ok board
        else
          Err AlreadyTaken
