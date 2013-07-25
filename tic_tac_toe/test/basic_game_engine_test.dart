import 'package:unittest/unittest.dart';
import 'package:tic_tac_toe/tic_tac_toe.dart';
import "package:logging/logging.dart";
import "package:logging_handlers/logging_handlers_shared.dart";
import 'input_games.dart';

////////////////////////////////////////////////////////////////////////////////
// Tests to ensure the game engine deals with moves and interfaces to the tic
// tac toe board
////////////////////////////////////////////////////////////////////////////////
main() {

  final _logger = new Logger("basic_game_engine_test");

  // Use this when logging desired this set of tests
  if(false) {
    Logger.root.onRecord.listen(new PrintHandler());
    Logger.root.level = Level.FINE;
  }

  const pos00  = const BoardLocation(0, 0);
  const pos10  = const BoardLocation(1, 0);

  group('Whos Turn Is It?:', () {
    test('X is next', () {
      xTurnNext.forEach((boardMatrix) {
        IGameEngine engine = new BasicGameEngine.fromMatrix(boardMatrix);
        expect(engine.nextPlayer, Player.PLAYER_X);
        IGameEngine swappedEngine = 
          new BasicGameEngine.fromMatrix(swapPlayers(boardMatrix),
                                         Player.PLAYER_O);
        expect(swappedEngine.nextPlayer, Player.PLAYER_O);
      });
    });
  });

  group('Basic Engine Move Correctness:', () {
    test('X Goes First', () {
      IGameEngine gameEngine = new BasicGameEngine();
      expect(gameEngine.positionState(pos00), PositionState.EMPTY);
      gameEngine.makeMove(new PlayerMove(Player.PLAYER_X, pos00));
      expect(gameEngine.positionState(pos00), PositionState.HAS_X);
    });

    test('X Goes First Exception', () {
      IGameEngine gameEngine = new BasicGameEngine(Player.PLAYER_O);
      try {
        gameEngine.makeMove(new PlayerMove(Player.PLAYER_X, pos00));
        assert(null == "Excpected InvalidMove");
      } on InvalidMove catch(invalidMove) {
        expect(invalidMove.reason, InvalidMoveReason.OUT_OF_TURN);
        return;
      }
    });

    test('X Moves To Filled Position Exception', () {
      IGameEngine gameEngine = new BasicGameEngine();
      gameEngine.makeMove(new PlayerMove(Player.PLAYER_X, pos00));
      gameEngine.makeMove(new PlayerMove(Player.PLAYER_O, pos10));
      try {
        gameEngine.makeMove(new PlayerMove(Player.PLAYER_X, pos00));
        assert(null == "Excpected InvalidMove");
      } on InvalidMove catch(invalidMove) {
        expect(invalidMove.reason, InvalidMoveReason.BAD_LOCATION);
        return;
      }
    });

    test('X Moves On Game Over Exception', () {
      IGameEngine gameEngine = 
        new BasicGameEngine.fromMatrix(xWins['horizontal_0']);
      try {
        gameEngine.makeMove(new PlayerMove(Player.PLAYER_O, pos00));
        assert(null == "Excpected InvalidMove");
      } on InvalidMove catch(invalidMove) {
        expect(invalidMove.reason, InvalidMoveReason.GAME_OVER);
        return;
      }
    });

    test('Invalid Board - Who Moves Next', () {
      try {
        // Create engine where it is clearly O's turn but try to make it X's
        // turn
        IGameEngine gameEngine = 
          new BasicGameEngine.fromMatrix(oTurn, Player.PLAYER_X);      
        assert(null == "Excpected InvalidBoard");
      } on InvalidBoard catch(e) {
        _logger.info("Got expected: $e");
      } catch(e) {
        assert(null == "Excpected InvalidBoard");
      }

      try {
        IGameEngine gameEngine = 
          new BasicGameEngine.fromMatrix(tooManyX);      
        assert(null == "Excpected InvalidBoard");
      } on InvalidBoard catch(e) {
        _logger.info("Got expected: $e");
      } catch(e) {
        assert(null == "Excpected InvalidBoard");
      }
    });

    test('X turn attempting undo X move', () {
      IGameEngine gameEngine = new BasicGameEngine.fromMatrix(emptyGame);
      var firstMove = new PlayerMove(Player.PLAYER_X, pos00);
      gameEngine.makeMove(firstMove);
      expect(gameEngine.positionState(pos00), PositionState.HAS_X);
      gameEngine.undoMove(firstMove);
      expect(gameEngine.positionState(pos00), PositionState.EMPTY);
      gameEngine.makeMove(firstMove);
      var secondMove = new PlayerMove(Player.PLAYER_O, pos10);
      gameEngine.makeMove(secondMove);
      expect(gameEngine.positionState(pos10), PositionState.HAS_O);
      try {
        gameEngine.undoMove(firstMove);
        assert(null == "Excpected InvalidMove");
      } on InvalidUndoOperation catch(e) {
        return;
      }
      try {
        gameEngine.undoMove(new PlayerMove(Player.PLAYER_X, pos10));
        assert(null == "Excpected InvalidUndoOperation");
      } on InvalidUndoOperation catch(e) {
        // expected
      } catch(e) {
        assert(null == "Unexpected Exception");
      }

      try {
        gameEngine.undoMove(new PlayerMove(Player.PLAYER_X, 
                new BoardLocation(1,1)));
        assert(null == "Excpected InvalidUndoOperation");
      } on InvalidUndoOperation catch(e) {
        // expected
      } catch(e) {
        assert(null == "Unexpected Exception");
      }

      gameEngine.undoMove(secondMove);
      gameEngine.undoMove(firstMove);
      expect(gameEngine.potentialMoves.length, 
          gameEngine.gameDim * gameEngine.gameDim);
    });

    test('Games end in CAT', () {
      xTurnNext.forEach((boardMatrix) {
        IGameEngine engine = new BasicGameEngine.fromMatrix(boardMatrix);
        while(!engine.isGameOver)
          engine.engineMove();
        expect(engine.isCatGame, true);
      });
    });


  });

}