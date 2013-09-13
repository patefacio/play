part of tic_tac_toe;

/// Row and column indentifying location on board
class BoardLocation {

  const BoardLocation(this.row, this.column);

  final int row;
  final int column;

  // custom <class BoardLocation>

  String toString() => '($row, $column)';

  // end <class BoardLocation>
}

/// Indicates a move of player to specified location
class PlayerMove {

  const PlayerMove(this.player, this.location);

  final Player player;
  final BoardLocation location;

  // custom <class PlayerMove>

  int get row => location.row;

  int get column => location.column;

  String toString() => '${player} move => (${row}, ${column})';

  // end <class PlayerMove>
}

/// Interface to a tic-tac-toe board
abstract class IBoard {

  // custom <class IBoard>

  bool get xHasWon;

  bool get oHasWon;

  /// Returns true if this is a cat game. Note it is only a CAT game at the end,
  /// prior to that it is simply an incomplete game even if two bright players
  /// guarantee it will end in CAT.
  bool get isCatGame;

  bool get isGameOver;

  bool playerHasWon(Player player);

  List<BoardLocation> get potentialMoves;

  GameState get gameState;

  int get gameDim;

  void _move(PlayerMove playerMove);

  /// Undoes the specified move. If the move specified is not one that exists on
  /// the board an InvalidUndo exception will be thrown
  void _undo(PlayerMove playerMove);

  // end <class IBoard>
}

/// 
/// Interface to the game play engine. The engine can automate a move for
/// *either* player via [engineMove]. Alternatively, the interface
/// supports non-automated moves via [makeMove].
///
///
abstract class IGameEngine {

  // custom <class IGameEngine>

  PositionState positionState(BoardLocation location);

  /// A request for the next move from the game engine. Calling this should have
  /// no impact on the game state - it should be a means for determining the
  /// next automated move.
  PlayerMove nextMove();

  /// Perform an automated move using implementation's strategy via nextMove
  PlayerMove engineMove() {
    PlayerMove result = nextMove();
    makeMove(result);
    return result;
  }

  PlayerMove createMove(BoardLocation location);

  GameState makeMove(PlayerMove move);

  void undoMove(PlayerMove move);

  GameState get gameState;

  Player get nextPlayer;

  bool get isGameOver;

  List<BoardLocation> get potentialMoves;

  void startNewGame([Player firstMover]);

  bool playerHasWon(Player player);

  bool get isCatGame;

  // end <class IGameEngine>
}
// custom <part tic_tac_toe>
// end <part tic_tac_toe>

