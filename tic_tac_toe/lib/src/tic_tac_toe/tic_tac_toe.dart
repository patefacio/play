part of tic_tac_toe;

/// Attempted an undo move that does not match move
class InvalidUndoOperation {
  InvalidUndoOperation(
    this.message
  ) {

  }

  /// Info about the invalid undo
  String message;
}

/// Board is in invalid state.  This can be caused by providing an invalid board
/// matrix, for example if there are too many X or Os or if [whoMovesNext] is
/// provided and not a valid option.
class InvalidBoard {
  InvalidBoard(
    this.message
  ) {

  }

  /// Info about the invalid undo
  String message;
}

/// Exception indicating move to location already filled
class InvalidMove implements Exception {
  InvalidMove(
    this.playerMove,
    this.reason
  ) {

  }

  /// Move that was rejected
  PlayerMove playerMove;
  /// Why the move was rejected
  InvalidMoveReason reason;

  // custom <class InvalidMove>
  String toString() => 'Invalid Move ${playerMove} reason => $reason';
  // end <class InvalidMove>
}

/// Accumulation of counts of the three possible states on a board
class StateCounts {
  int xCount = 0;
  int oCount = 0;
  int emptyCount = 0;

  // custom <class StateCounts>

  StateCounts(List<List<PositionState>> states) {
    states.forEach((row) =>
        row.forEach((state) {
          switch(state) {
            case PositionState.EMPTY:
              emptyCount++;
              break;
            case PositionState.HAS_X:
              xCount++;
              break;
            case PositionState.HAS_O:
              oCount++;
              break;
            default:
              assert("Invalid state ${state}" == null);
          }
        }));
  }

  // end <class StateCounts>
}

/// Row and column indentifying location on board
class BoardLocation {
  const BoardLocation(
    this.row,
    this.column
  );

  /// Row for the move
  final int row;
  /// Column for the move
  final int column;

  // custom <class BoardLocation>

  String toString() => '($row, $column)';

  // end <class BoardLocation>
}

/// Indicates a move of player to specified location
class PlayerMove {
  const PlayerMove(
    this.player,
    this.location
  );

  /// Player (x or o) moving to location
  final Player player;
  /// Location of the move
  final BoardLocation location;

  // custom <class PlayerMove>

  /// Row of the move
  int get row => location.row;

  /// Column of the move
  int get column => location.column;

  String toString() => '${player} move => (${row}, ${column})';

  // end <class PlayerMove>
}

/// Interface to a tic-tac-toe board
abstract class IBoard {

  // custom <class IBoard>

  /// Returns true if x has won the game
  bool get xHasWon;

  /// Returns true if o has won the game
  bool get oHasWon;

  /// Returns true if this is a cat game. Note it is only a CAT game at the end,
  /// prior to that it is simply an incomplete game even if two bright players
  /// guarantee it will end in CAT.
  bool get isCatGame;

  /// The game has ended in a win or cat game
  bool get isGameOver;

  /// Returns true of player has one the game
  bool playerHasWon(Player player);

  /// Returns a list of potential moves available on the board
  List<BoardLocation> get potentialMoves;

  /// Returns the current state of the game
  GameState get gameState;

  /// Dimensions of the board
  int get gameDim;

  /// Performs the specified move
  void _move(PlayerMove playerMove);

  /// Undoes the specified move. If the move specified is not one that exists on
  /// the board an InvalidUndo exception will be thrown
  void _undo(PlayerMove playerMove);

  // end <class IBoard>
}

/// Interface to the game play engine
abstract class IGameEngine {

  // custom <class IGameEngine>

  /// Find the state of a position on the board
  PositionState positionState(BoardLocation location);

  /// A request for the next move from the game engine. Calling this should have
  /// no impact on the game state - it should only determine the next move
  PlayerMove nextMove();

  /// Perform an automated move using implementation's strategy via nextMove
  PlayerMove engineMove() {
    PlayerMove result = nextMove();
    makeMove(result);
    return result;
  }

  /// Create a move for the current user destined for location
  PlayerMove createMove(BoardLocation location);

  /// Perform a move and return state of game post move. May be used by "manual"
  /// player
  GameState makeMove(PlayerMove move);

  /// Undo last move
  void undoMove(PlayerMove move);

  /// Return current state of game
  GameState get gameState;

  /// Based on current state of game, who should move next
  Player get nextPlayer;

  /// Returns true if game is over
  bool get isGameOver;

  /// Returns list of all empty slots
  List<BoardLocation> get potentialMoves;

  /// Reset the board to the original state
  void startNewGame([Player firstMover]);

  /// Returns true of player has one the game
  bool playerHasWon(Player player);

  /// Returns true if this is a cat game.
  bool get isCatGame;

  // end <class IGameEngine>
}
// custom <part tic_tac_toe>
// end <part tic_tac_toe>

