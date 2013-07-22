part of engine;

/// Exception indicating move to location already filled
class InvalidMoveLocation implements Exception { 
  String playerMove;

  // custom <class InvalidMoveLocation>
  // end <class InvalidMoveLocation>
}

/// Exception indicating move by player who just moved
class InvalidMoveOutOfTurn implements Exception { 

  // custom <class InvalidMoveOutOfTurn>
  // end <class InvalidMoveOutOfTurn>
}

/// Exception indicating attempted move when game is complete
class InvalidMoveGameOver implements Exception { 

  // custom <class InvalidMoveGameOver>
  // end <class InvalidMoveGameOver>
}

/// Indicates a move of player to specified x,y location
class PlayerMove { 
  PlayerMove(
    this.player,
    this.row,
    this.column
  ) {
  
  }
  
  /// Player (x or o) moving to location
  final Player player;
  /// Row for the move
  final int row;
  /// Column for the move
  final int column;

  // custom <class PlayerMove>

  String toString() => '${player} move => (${row}, ${column})';
  
  // end <class PlayerMove>
}

/// Interface to a tic-tac-toe board
abstract class IBoard { 

  // custom <class IBoard>

  bool horizontalWinner(Player player);
  bool verticalWinner(Player player);
  bool forwardDiagonalWinner(Player player);
  bool backDiagonalWinner(Player player);
  PositionState positionState(int row, int column) =>
    _positionStates[row][column];

  bool playerHasWon(Player player) =>
    horizontalWinner(player) ||
    verticalWinner(player) ||
    forwardDiagonalWinner(player) ||
    backDiagonalWinner(player);

  bool get xHasWon => playerHasWon(Player.PLAYER_X);
  bool get oHasWon => playerHasWon(Player.PLAYER_O);
  bool get isComplete;

  void _move(PlayerMove playerMove);

  GameState get gameState =>
      xHasWon ? GameState.X_WON : (
          oHasWon ? GameState.Y_WON : (
              isComplete ? GameState.COMPLETE : GameState.INCOMPLETE));

  // end <class IBoard>
}

/// Implementation of tick tack toe board
class Board extends IBoard { 
  Board(
    [
      this._gameDim = 3
    ]
  ) {
    // custom <Board>

    startNewGame();

    // end <Board>
  }
  
  final int _gameDim;
  /// Dimensions of the game
  int get gameDim => _gameDim;
  /// Represents the state of each of the positions in the game
  List<List<PositionState>> _positionStates;

  // custom <class Board>

  Board.fromMatrix(List<List<PositionState>> positionStates) : 
    _gameDim = positionStates.length,
    _positionStates = positionStates {
    
  }

  /// Set state to cleared board
  void startNewGame() {
    _positionStates = 
      new List.filled(_gameDim, 
          new List.filled(_gameDim, PositionState.EMPTY));
  }

  PositionState _playerTargetState(Player player) =>
    (player == Player.PLAYER_X) ? 
    PositionState.HAS_X : PositionState.HAS_O;

  bool horizontalWinner(Player player) {
    final PositionState targetState = _playerTargetState(player);
    return _positionStates.any((row) => 
        row.every((ps) => ps == targetState));
  }

  bool verticalWinner(Player player) {
    final PositionState targetState = _playerTargetState(player);
    for(int columnIndex = 0; columnIndex < _gameDim; columnIndex++) {
      bool allMatch = true;
      for(int rowIndex = 0; allMatch && (rowIndex < _gameDim); rowIndex++) {
        allMatch = allMatch && 
          (_positionStates[rowIndex][columnIndex] == targetState);
      }
      if(allMatch)
        return true;
    }
    return false;
  }

  bool forwardDiagonalWinner(Player player) {
    final PositionState targetState = _playerTargetState(player);
    final int lastIndex = _gameDim - 1;
    for(int i = 0; i < _gameDim; i++) {
      if(_positionStates[lastIndex-i][i] != targetState)
        return false;
    }
    return true;
  }

  bool backDiagonalWinner(Player player) {
    final PositionState targetState = _playerTargetState(player);
    for(int i = 0; i < _gameDim; i++) {
      if(_positionStates[i][i] != targetState)
        return false;
    }
    return true;
  }

  void _move(PlayerMove playerMove) {
    _positionStates[playerMove.row][playerMove.column] = 
      (playerMove.player == Player.PLAYER_X)? PositionState.HAS_X :
      PositionState.HAS_Y;
  }  

  bool get xHasWon => true;
  bool get oHasWon => false;
  bool get isComplete => false;

  String toString() => _positionStates.toString();

  // end <class Board>
}

/// Interface to the game play engine
abstract class IGameEngine { 

  // custom <class IGameEngine>


  PositionState positionState(int row, int column);

  PlayerMove nextMove();

  void engineMove() => move(nextMove());

  void move(PlayerMove playerMove);

  GameState get gameState;
  

  // end <class IGameEngine>
}

/// One approach to playing the game
class BasicGameEngine implements IGameEngine { 
  BasicGameEngine(
    [
      this._nextPlayer = Player.PLAYER_X
    ]
  ) {
  
  }
  
  /// Board for a game of tic-tac-toe
  Board _board = new Board();
  /// Next player to move - X goes first by default
  Player _nextPlayer;

  // custom <class BasicGameEngine>

  PositionState positionState(int row, int column) => 
    _board.positionState(row, column);

  PlayerMove nextMove() {
    print("Calculating next move");
    return new PlayerMove(_nextPlayer, 0, 0);
  }

  void move(PlayerMove playerMove) {
    print("move of: ${playerMove}");

    if(_nextPlayer != playerMove.player) 
      throw new InvalidMoveOutOfTurn();

    PositionState currentState = 
      _board.positionState(playerMove.row, playerMove.column);

    if(currentState != PositionState.EMPTY)
      throw new InvalidMoveLocation();

    _board._move(playerMove);
    _nextPlayer = (_nextPlayer == Player.PLAYER_X)?
      Player.PLAYER_O : Player.PLAYER_X;
  }

  GameState get gameState => _board.gameState;

  // end <class BasicGameEngine>
}
// custom <part engine>

// end <part engine>

