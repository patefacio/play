part of engine;

/// Attempted an undo move that does not match
class InvalidUndo { 

  // custom <class InvalidUndo>
  // end <class InvalidUndo>
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
  bool get isCatGame;
  bool get isGameOver;

  List<BoardLocation> get potentialMoves;
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
  int _emptySlots;
  /// Number of slots that are currently empty
  int get emptySlots => _emptySlots;

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

  PositionState positionState(BoardLocation location) =>
    _positionStates[location.row][location.column];

  List<BoardLocation> get potentialMoves {
    List<BoardLocation> result = [];

    if(isGameOver)
      return result;

    for(int row = 0; row < _gameDim; row++) {
      for(int column = 0; column < _gameDim; column++) {
        if(_positionStates[row][column] == PositionState.EMPTY) 
          result.add(new BoardLocation(row, column));
      }
    }
    return result;
  }

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
  bool get isCatGame => _gameState == GameState.CAT_GAME;
  bool get isGameOver => _gameState != GameState.INCOMPLETE;

  void _updateGameState() {
    _gameState =
      xHasWon ? GameState.X_WON : (
          oHasWon ? GameState.O_WON : (
              _emptySlots == 0 ? GameState.CAT_GAME : GameState.INCOMPLETE));
  }

  void _move(PlayerMove playerMove) {
    _positionStates[playerMove.row][playerMove.column] = 
      (playerMove.player == Player.PLAYER_X)? PositionState.HAS_X :
      PositionState.HAS_O;
    _emptySlots -= 1;
    _updateGameState();
    assert(_emptySlots >= 0);
  }

  void _undo(PlayerMove playerMove) {
    final PositionState targetState = _playerTargetState(playerMove.player);
    if(_positionStates[playerMove.row][playerMove.column] != targetState) {
      throw new InvalidUndoOperation();
    } else {
      _positionStates[playerMove.row][playerMove.column] = PositionState.EMPTY;
      _emptySlots++;
      _gameState = GameState.INCOMPLETE;
    }
  }

  String toString() => '''
dim: ${_gameDim}
state: ${_gameState}
board: \n${_positionStates.join('\n')}
''';

  // end <class Board>
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

  /// Perform a move and return state of game post move. May be used by "manual"
  /// player
  GameState makeMove(PlayerMove move);

  /// Undo last move
  void undoMove(PlayerMove move);

  /// Return current state of game
  GameState get gameState;

  /// Based on current state of game, who should move next
  Player get nextPlayer;

  bool get isGameOver;

  // end <class IGameEngine>
}

/// One approach to playing the game
class BasicGameEngine extends IGameEngine { 
  BasicGameEngine(
    [
      this._nextPlayer = Player.PLAYER_X
    ]
  ) {
  
  }
  
  /// Board for a game of tic-tac-toe
  Board _board = new Board();
  Player _nextPlayer;
  /// Next player to move - X goes first by default
  Player get nextPlayer => _nextPlayer;

  // custom <class BasicGameEngine>

  /// When creating an engine from an existing board need to determine who moves
  /// next.
  void _determineNextPlayer(Player whoMovesNext) {
    final gameDim = _board._gameDim;
    final states = _board._positionStates;
    if(!_board.isGameOver) {
      // Determine next player from state of board
      int countX = 0;
      int countO = 0;
      for(int row = 0; row < gameDim; row++) {
        for(int column = 0; column < gameDim; column++) {
          var value = states[row][column];
          if(value == PositionState.HAS_X)
            countX++;
          if(value == PositionState.HAS_O)
            countO++;
        }
      }

      if((countX - countO).abs() > 1) {
        throw InvalidBoard(_board);
      }

      if(countX == countO) {
        _nextPlayer = (whoMovesNext != null)? whoMovesNext: Player.PLAYER_X;
      } else {

        _nextPlayer = 
          (countX > countO)? Player.PLAYER_O : Player.PLAYER_X;

        if(whoMovesNext != null && whoMovesNext != _nextPlayer) {
          throw InvalidBoard(_board);          
        }
      }
    }
  }

  BasicGameEngine.fromMatrix(List<List<PositionState>> positionStates,
                             [ Player whoMovesNext ]) {
    _board = new Board.fromMatrix(positionStates);
    _determineNextPlayer(whoMovesNext);
  }

  PositionState positionState(BoardLocation location) => 
    _board.positionState(location);

  PlayerMove _createMove(BoardLocation location) => 
    new PlayerMove(_nextPlayer, location);

  dynamic _tryMove(BoardLocation location, dynamic thenWhat()) {
    var someMove = _createMove(location);
    makeMove(someMove);
    dynamic result;
    try {
      result = thenWhat();
    } finally {
      undoMove(someMove);
    }
    return result;
  }

  bool atLeastADraw(BoardLocation location, [int i = 0]) {
    var me = _nextPlayer;

    return _tryMove(location, () {
      if(playerHasWon(me.opponent)) {
        return false;
      } else if(isGameOver) {
        return true;
      } else {
        return _board.potentialMoves.every((hisSpot) {
          return _tryMove(hisSpot, () {
            if(playerHasWon(me.opponent)) {
              return false;
            } else if(isGameOver) {
              return true;
            } else {
              return _board.potentialMoves.any((myNextSpot) =>
                  atLeastADraw(myNextSpot, ++i));
            }
          });
        });
      }
    });

    return result;
  }

  PlayerMove nextMove() {
    var locations = _board.potentialMoves;
    return _createMove(
        _board.potentialMoves.firstWhere((location) => atLeastADraw(location),
            orElse: () {
              return locations.first;
            }));
  }

  void _switchPlayers() {
    _nextPlayer = (_nextPlayer == Player.PLAYER_X)?
      Player.PLAYER_O : Player.PLAYER_X;
  }

  GameState makeMove(PlayerMove playerMove) {
    if(_board.isGameOver) {
      throw new InvalidMove(playerMove, InvalidMoveReason.GAME_OVER);
    }

    if(_nextPlayer != playerMove.player) 
      throw new InvalidMove(playerMove, InvalidMoveReason.OUT_OF_TURN);

    PositionState currentState = 
      _board.positionState(playerMove.location);

    if(currentState != PositionState.EMPTY)
      throw new InvalidMove(playerMove, InvalidMoveReason.BAD_LOCATION);

    _board._move(playerMove);

    _switchPlayers();

    return gameState;
  }

  void undoMove(PlayerMove move) {
    _board._undo(move);
    _switchPlayers();
  }

  GameState get gameState => _board.gameState;
  bool playerHasWon(Player player) => _board.playerHasWon(player);
  bool get isCatGame => _board.isCatGame;
  bool get isGameOver => _board.isGameOver;

  String toString() => _board.toString();

  // end <class BasicGameEngine>
}
// custom <part engine>

// end <part engine>

