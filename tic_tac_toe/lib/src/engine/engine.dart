part of engine;

/// Attempted an undo move that does not match
class InvalidUndo { 

  // custom <class InvalidUndo>
  // end <class InvalidUndo>
}

/// Board is in invalid state
class InvalidBoard { 

  // custom <class InvalidBoard>
  // end <class InvalidBoard>
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
              assert("Invalid state ${states[row][column]}" == null);
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

  /// Performs the specified move
  void _move(PlayerMove playerMove);

  /// Undoes the specified move. If the move specified is not one that exists on
  /// the board an InvalidUndo exception will be thrown
  void _undo(PlayerMove playerMove);

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

  /// Deep copy the matrix
  static List<List<PositionState>> deepCopy(List<List<PositionState>> src) =>
    new List.generate(src.length, (i) => new List.from(src[i]));

  /// Create the board from the specified matrix. 
  /// 
  /// If the board is invalid InvalidBoard will be thrown
  Board.fromMatrix(List<List<PositionState>> positionStates) : 
    _gameDim = positionStates.length,
    _positionStates = deepCopy(positionStates)
  {
    StateCounts counts = new StateCounts(positionStates);

    if((counts.xCount - counts.oCount).abs() > 1) {
      throw InvalidBoard(positionStates);
    }

    _emptySlots = counts.emptyCount;
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
      _positionStates = new List.generate(_gameDim, 
          (_) => new List.filled(_gameDim, PositionState.EMPTY));
    } else {
      _positionStates.forEach((row) => row.fillRange(0, _gameDim, PositionState.EMPTY));
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

  /// Sets the game state based on current board status
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

  bool get isGameOver;

  /// Returns list of all empty slots
  List<BoardLocation> get potentialMoves;

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

      StateCounts counts = new StateCounts(states);

      if(counts.xCount == counts.oCount) {
        _nextPlayer = (whoMovesNext != null)? whoMovesNext: Player.PLAYER_X;
      } else {

        _nextPlayer = 
          (counts.xCount > counts.oCount)? Player.PLAYER_O : Player.PLAYER_X;

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

  PlayerMove createMove(BoardLocation location) => 
    new PlayerMove(_nextPlayer, location);

  dynamic _tryMove(BoardLocation location, dynamic thenWhat()) {
    var someMove = createMove(location);
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
    return createMove(
        _board.potentialMoves.firstWhere((location) => atLeastADraw(location),
            orElse: () {
              _logger.warning("Potential loss ahead ${_board}");
              return locations.first;
            }));
  }


  /// Replace current player with opponent
  _switchPlayers() => _nextPlayer = _nextPlayer.opponent;

  /// Make the move specified by [playerMove], update the state of the board and
  /// adjust player.
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

  /// Undo the [move] specified and adjust the player. Will throw if [move] not
  /// present on board
  void undoMove(PlayerMove move) {

    // Can only undo move of last players move, not next players
    if(move.player == _nextPlayer)
      throw InvalidUndoOperation();

    _board._undo(move);
    _switchPlayers();
  }

  GameState get gameState => _board.gameState;
  bool playerHasWon(Player player) => _board.playerHasWon(player);
  bool get isCatGame => _board.isCatGame;
  bool get isGameOver => _board.isGameOver;
  List<BoardLocation> get potentialMoves => _board.potentialMoves;
  String toString() => _board.toString();
  int get emptySlots => _board._emptySlots;

  // end <class BasicGameEngine>
}
// custom <part engine>

// end <part engine>

