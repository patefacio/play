part of engine;

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

  bool get xHasWon;
  bool get oHasWon;
  bool get isGameOver;
  GameState get gameState;
  void _move(PlayerMove playerMove);

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
  GameState _gameState;
  /// State of game - updated on completion of each move
  GameState get gameState => _gameState;
  /// Number of slots that are currently empty
  int _emptySlots;

  // custom <class Board>

  Board.fromMatrix(List<List<PositionState>> positionStates) : 
    _gameDim = positionStates.length,
    _positionStates = positionStates 
  {
    _emptySlots = 0;
    for(int row = 0; row < _gameDim; row++) {
      for(int column = 0; column < _gameDim; column++) {
        if(_positionStates[row][column] == PositionState.EMPTY) {
          _emptySlots++;
        }
      }
    }
    _updateGameState();
  }

  PositionState positionState(int row, int column) =>
    _positionStates[row][column];

  /// Set state to cleared board
  void startNewGame() {
    if(_positionStates == null) {
      _positionStates = new List(_gameDim);
      for(int row = 0; row < _gameDim; row++) {
        _positionStates[row] = new List.filled(_gameDim, PositionState.EMPTY);
      }
    } else {
      for(int row = 0; row < _gameDim; row++) {
        for(int column = 0; column < _gameDim; column++) {
          _positionStates[row][column] = PositionState.EMPTY;
        }
      }
    }
    _emptySlots = _gameDim * _gameDim;
    _gameState = GameState.INCOMPLETE;
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

  bool playerHasWon(Player player) =>
    horizontalWinner(player) ||
    verticalWinner(player) ||
    forwardDiagonalWinner(player) ||
    backDiagonalWinner(player);

  bool get xHasWon => playerHasWon(Player.PLAYER_X);
  bool get oHasWon => playerHasWon(Player.PLAYER_O);
  bool get isGameOver => _gameState != GameState.INCOMPLETE;

  void _updateGameState() {
    _gameState =
      xHasWon ? GameState.X_WON : (
          oHasWon ? GameState.Y_WON : (
              _emptySlots == 0 ? GameState.COMPLETE : GameState.INCOMPLETE));
  }

  void _move(PlayerMove playerMove) {
    _positionStates[playerMove.row][playerMove.column] = 
      (playerMove.player == Player.PLAYER_X)? PositionState.HAS_X :
      PositionState.HAS_O;
    _emptySlots -= 1;
    _updateGameState();
    print("Post move state ${gameState}");
    assert(_emptySlots >= 0);
  }  

  String toString() => '''
dim: ${_gameDim}
state: ${_gameState}
board: ${_positionStates.join('\n')}
''';

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

  BasicGameEngine.fromMatrix(List<List<PositionState>> positionStates) {
    _board = new Board.fromMatrix(positionStates);
    if(!_board.isGameOver) {
      // Determine next player from state of board
      int countX = 0;
      int countO = 0;
      for(int row = 0; row < _gameDim; row++) {
        for(int column = 0; column < _gameDim; column++) {
          var value = _positionStates[row][column];
          if(value == PositionState.HAS_X)
            countX++;
          if(value == PositionState.HAS_O)
            countO++;
        }
      }

      if(abs(countX - countO) > 1) {
        throw InvalidBoard(_board);
      }

      _nextPlayer = 
        (countX > countO)? Player.PLAYER_O : Player.PLAYER_X;

      print("Games next $_nextPlayer");
    }
  }

  PositionState positionState(int row, int column) => 
    _board.positionState(row, column);

  PlayerMove nextMove() {
    print("Calculating next move");
    return new PlayerMove(_nextPlayer, 0, 0);
  }

  void move(PlayerMove playerMove) {
    if(_board.isGameOver) {
      print("OOPS game over ${_board}");
      throw new InvalidMove(playerMove, InvalidMoveReason.GAME_OVER);
    }

    if(_nextPlayer != playerMove.player) 
      throw new InvalidMove(playerMove, InvalidMoveReason.OUT_OF_TURN);

    PositionState currentState = 
      _board.positionState(playerMove.row, playerMove.column);

    if(currentState != PositionState.EMPTY)
      throw new InvalidMove(playerMove, InvalidMoveReason.BAD_LOCATION);

    _board._move(playerMove);
    _nextPlayer = (_nextPlayer == Player.PLAYER_X)?
      Player.PLAYER_O : Player.PLAYER_X;
  }

  GameState get gameState => _board.gameState;

  String toString() => _board.toString();

  // end <class BasicGameEngine>
}
// custom <part engine>

// end <part engine>

