import 'package:unittest/unittest.dart';
import 'package:tic_tac_toe/tic_tac_toe.dart';
import "package:logging/logging.dart";
import 'input_games.dart';

////////////////////////////////////////////////////////////////////////////////
// Tests to ensure the game engine deals with moves and interfaces to the tic
// tac toe board
////////////////////////////////////////////////////////////////////////////////
main() {

  final _logger = new Logger("basic_game_engine_test");

  // Use this when logging desired this set of tests
  if(false) {
    Logger.root.onRecord.listen((LogRecord r) =>
        print("${r.loggerName} [${r.level}]:\t${r.message}"));
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