module Tests (..) where

import Ttt exposing (Either(..), Cell, BadMove(..))
import ElmTest exposing (..)


cells : Test
cells =
  suite
    "Cell values"
    [ test "X" (assertEqual (Ttt.cellValue Ttt.X) 1)
    , test "O" (assertEqual (Ttt.cellValue Ttt.O) -1)
    , test "N" (assertEqual (Ttt.cellValue Ttt.N) 0)
    ]


xat0_0 : Ttt.Board
xat0_0 =
  case Ttt.move ( 0, 0 ) Ttt.X Ttt.emptyBoard of
    Good b ->
      b

    _ ->
      Debug.crash "Should not happen"


invalidMove : Ttt.BadMove
invalidMove =
  case Ttt.move ( -1, -2 ) Ttt.X Ttt.emptyBoard of
    Bad b ->
      b

    _ ->
      Debug.crash "Expecting error"


alreadyTaken : Ttt.BadMove
alreadyTaken =
  let
    b =
      case Ttt.move ( 2, 2 ) Ttt.X Ttt.emptyBoard of
        Good g ->
          g

        _ ->
          Debug.crash "Should be possible do first move"
  in
    case Ttt.move ( 2, 2 ) Ttt.O b of
      Bad b ->
        b

      _ ->
        Debug.crash "Should not be possible to take already taken spot"


board : Test
board =
  suite
    "Board building"
    [ test "empty board has nothing" (assertEqual (Just Ttt.N) (Ttt.cellAt ( 0, 0 ) Ttt.emptyBoard))
    , test "valid move is found" (assertEqual (Just Ttt.X) (Ttt.cellAt ( 0, 0 ) xat0_0))
    , test "invalid move is rejected" (assertEqual (InvalidCell ( -1, -2 )) invalidMove)
    ]


all : Test
all =
  suite
    "All tests"
    [ cells
    , board
    ]
