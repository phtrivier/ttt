module Tests (..) where

import Ttt exposing (Cell, BadMove(..))
import ElmTest exposing (..)
import Result exposing (..)


cells : Test
cells =
  suite
    "Cell values"
    [ test "X" (assertEqual (Ttt.cellValue Ttt.X) 1)
    , test "O" (assertEqual (Ttt.cellValue Ttt.O) -1)
    , test "N" (assertEqual (Ttt.cellValue Ttt.N) 0)
    ]


xat0_0 : Result Ttt.BadMove Ttt.Board
xat0_0 =
  Ttt.move ( 0, 0 ) Ttt.X Ttt.emptyBoard


invalidMove : Result Ttt.BadMove Ttt.Board
invalidMove =
  Ttt.move ( -1, -2 ) Ttt.X Ttt.emptyBoard


alreadyTaken : Result Ttt.BadMove Ttt.Board
alreadyTaken =
  Ttt.move ( 2, 2 ) Ttt.X Ttt.emptyBoard
    `Result.andThen` Ttt.move ( 2, 2 ) Ttt.O


board : Test
board =
  suite
    "Board building"
    [ test "empty board has nothing" (assertEqual (Just Ttt.N) (Ttt.cellAt ( 0, 0 ) Ttt.emptyBoard))
    , test
        "valid move is found in board"
        (assertEqual
          (Just Ttt.X)
           -- I kinda wish there was a more readable version of this...
           ((Result.toMaybe xat0_0)
            `Maybe.andThen` (Ttt.cellAt ( 0, 0 ))
          )
        )
    , test "invalid move is rejected" (assertEqual (Err (InvalidCell ( -1, -2 ))) invalidMove)
    , test "already taken" (assertEqual (Err AlreadyTaken) alreadyTaken)
    ]


all : Test
all =
  suite
    "All tests"
    [ cells
    , board
    ]
