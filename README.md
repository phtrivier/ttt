# TTT

An exercice of style in modeling Tic-Tac-Toe.
This is more to ask questions than anything.

DON'T TREAT THIS AS GOOD CODE ;) !

## How would you model 'a board that must be 3x3' ?

Let's model tic-tac-toe.

Intuitively, we need commands to :

- create an empty board
- let a player (X or O) play

And we need queries to know : 

- what's on a given cell of the board ?
- has any of the player won ?

### Naïve implementation

Assume the tic-tac-toe board should be 3x3.

Let's say we model the board as a mapping between positions and cell value.
Naïvely, we would use a tuple `(i,j)` for a position.

```elm
type Cell
  = X
  | O
  | N

type alias Board =
  Dict ( Int, Int ) Cell

-- Obviously a bad implementation, but bear with me. 
emptyBoard : Board
emptyBoard =
  Dict.empty
      |> Dict.insert (0,0) N
      |> Dict.insert (0,1) N
      |> Dict.insert (0,2) N
      |> Dict.insert (1,0) N
      |> Dict.insert (1,1) N
      |> Dict.insert (1,2) N
      |> Dict.insert (2,0) N
      |> Dict.insert (2,1) N
      |> Dict.insert (2,2) N

```
 
### Positions

Functions signatures are enough to discuss the issue, let's use the most naïve version first.

```elm
-- What's on a board at a given position ?
cellAt : ( Int, Int ) -> Board -> Cell

-- Check a cell, for a given player, on a Board, and return a new Board
move : ( Int, Int ) -> Cell -> Board -> Board
```

The problem is, those operations have no meaning at all on tuples that are 'out' of the board.

### Fixing `cellAt`

For the `cellAt` function, this can be solved with the `Maybe` type ; when referring to a position that is negative, or bigger than 3x3, we'll return `Nothing`.

```elm
cellAt : ( Int, Int ) -> Board -> Maybe Cell
```

### Fixing `move`

For the `move` function, it gets a bit more complicated :

- some position might be illegal in general (out of the board)
- some are only illegal at a given point (if you play on a cell that is already occupied.)

How to you model that ? From what I've read, you have several choices.

#### Using Maybe

Return `(Just Board)` if the operation is valid, `Nothing` otherwise.

```elm
-- Check a cell for a given player
move : ( Int, Int ) -> Cell -> Board -> Maybe Board
```

Pros:
- easy to understand

Cons:
- you can't communicate why the operation did not affect the board
- or if it did at all !

#### Using Either-ish

Return 'either' a new, updated `Board`, or... something else. I got creative :

```elm
-- Union type to return something Good or Bad (I feet Good / Bad is clearer than Left / Right)
type Either a b
  = Good a
  | Bad b

-- Enum type with everything that can cause an error
type BadMove
  = InvalidCell ( Int, Int )
  | AlreadyTaken

move : ( Int, Int ) -> Cell -> Board -> Either Board BadMove
```

Pros:
- you can communicate precisely if the operation meant something

Cons:
- this makes the API a bit clumsy to use when you want to chain calls to `move`, since you have to 'extract' the Good part all the time.

```elm

-- 'Chain' calls to 'move' to set the board in a specific state. Is there a better way to do this ? 
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
    , test "invalid move is rejected" (assertEqual (InvalidCell ( -1, -2 )) alreadyTaken)
    ]
```

This is what's implemented in this repository (for the sake of doing it - any comment welcome.)

#### Keeping things silent

Another option is to simply ignore any operation that does bad stuff, and leave the value of the board as is.

```elm
move : ( Int, Int ) -> Cell -> Board -> Board
```

The position is not right ? Just return the same board.
The player tries to play on an occupied cell ? Just return the same board.
Etc...

Pros:
- easy to code
- easy to chain calls

Cons:
- no way to communicate invalid API calls
- a bit harder to reason about for the user ?

#### Anything else

Are there alternatives ? What would be the 'idiomatic' / 'preferred' way to model such an issue ?
