part of tic_tac_toe;

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
  /// If the board is invalid InvalidBoard will be thrown. Deep copy is
  /// performed on [positionStates] since important to ensure data belongs to
  /// instance
  Board.fromMatrix(List<List<PositionState>> positionStates) : 
    _gameDim = positionStates.length,
    _positionStates = deepCopy(positionStates)
  {
    StateCounts counts = new StateCounts(positionStates);

    if((counts.xCount - counts.oCount).abs() > 1) {
      throw new InvalidBoard("Invalid board $positionStates");
    }

    _emptySlots = counts.emptyCount;
    _updateGameState();
  }

  /// Retrieve state for given position on board
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
      _positionStates.forEach((row) => 
          row.fillRange(0, _gameDim, PositionState.EMPTY));
    }
    _emptySlots = _gameDim * _gameDim;
    _gameState = GameState.INCOMPLETE;
  }

  /// Returns expected state of position if [player] is there
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

  /// Move the player to the location specified in the [playerMove]
  void _move(PlayerMove playerMove) {
    _positionStates[playerMove.row][playerMove.column] = 
      (playerMove.player == Player.PLAYER_X)? PositionState.HAS_X :
      PositionState.HAS_O;
    _emptySlots -= 1;
    _updateGameState();
    assert(_emptySlots >= 0);
  }

  /// Undo a specific move. NOTE: Checking is done to ensure the undone move
  /// exists and belongs to the player of the last move. However, no caching of
  /// moves is done, so it is possible to abuse [_undo] and undo a different
  /// move of the last player than his actual last move.
  void _undo(PlayerMove playerMove) {
    final PositionState targetState = _playerTargetState(playerMove.player);
    if(_positionStates[playerMove.row][playerMove.column] != targetState) {
      throw new 
       InvalidUndoOperation(
           "Invalid undo $playerMove state mismatch on board $_positionStates");
    } else {
      _positionStates[playerMove.row][playerMove.column] = PositionState.EMPTY;
      _emptySlots++;
      _gameState = GameState.INCOMPLETE;
    }
  }

  String toString() {
    String boardDisplay(PositionState state) =>
      (state == PositionState.HAS_X)? 'X' :
      (state == PositionState.HAS_O)? 'O' : ' ';

    return '''board:
${_positionStates.map((row) => 
   row.map((cell) => boardDisplay(cell)).join(' | '))
   .join('\n----------\n')}
''';

  }

  // end <class Board>
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
          throw new 
            InvalidBoard("Invalid board, $whoMovesNext not next: $_board");
        }
      }
    }
  }

  /// Construct a game engine from 2D matrix of position states. If there are an
  /// equal number of X and O then you can specify [whoMovesNext]. 
  BasicGameEngine.fromMatrix(List<List<PositionState>> positionStates,
                             [ Player whoMovesNext ]) {
    _board = new Board.fromMatrix(positionStates);
    _determineNextPlayer(whoMovesNext);
  }

  /// Create a move for the current player destined for [location]
  PlayerMove createMove(BoardLocation location) => 
    new PlayerMove(_nextPlayer, location);

  /// Attempts to move to location and after the move calls [thenWhat]. After
  /// the move the effects of it are undone.
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

  /// For a given [location] determines if after moving the [nextPlayer] there,
  /// that player will get at least a draw. The idea is: move to [location],
  /// then have the opponent try to move to each spot in turn. At each of his
  /// spots we evaluate all of our next moves to see what locations provide
  /// [atLeastADraw]. If after this move, for all positions of our opponent we
  /// can find at least one place to go to force a draw then we can achieve at
  /// least a draw.
  bool atLeastADraw(BoardLocation location) {
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
                  atLeastADraw(myNextSpot));
            }
          });
        });
      }
    });
  }

  /// Simple heuristic is to always just choose the first location that is at
  /// least a draw. This will not necessarily be the best move - but it will
  /// ensure that a complete game against the engine will result in a draw or
  /// win for the engine. To enhance more aggressively invest in choosing the
  /// best among all potentialMoves that are at least a draw.
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
    if(_board.isGameOver) 
      throw new InvalidMove(playerMove, InvalidMoveReason.GAME_OVER);

    if(_nextPlayer != playerMove.player) 
      throw new InvalidMove(playerMove, InvalidMoveReason.OUT_OF_TURN);

    PositionState currentState = _board.positionState(playerMove.location);

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
      throw new InvalidUndoOperation("Invalid $move out of order undo");

    _board._undo(move);
    _switchPlayers();
  }

  int get gameDim => _board.gameDim;
  IBoard get board => _board;
  GameState get gameState => _board.gameState;
  bool playerHasWon(Player player) => _board.playerHasWon(player);
  bool get isCatGame => _board.isCatGame;
  bool get isGameOver => _board.isGameOver;
  PositionState positionState(BoardLocation location) => 
    _board.positionState(location);
  List<BoardLocation> get potentialMoves => _board.potentialMoves;
  String toString() => board.toString();
  int get emptySlots => _board._emptySlots;

  void startNewGame([Player firstMover = Player.PLAYER_X]) {
    _nextPlayer = (firstMover != null)? firstMover : Player.PLAYER_X;
    _board.startNewGame();
  }


  // end <class BasicGameEngine>
}
// custom <part engine>
// end <part engine>

