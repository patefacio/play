import 'package:unittest/unittest.dart';
import 'package:tic_tac_toe/tic_tac_toe.dart';
import 'input_games.dart';

////////////////////////////////////////////////////////////////////////////////
// Tests to ensure the game engine deals with moves and interfaces to the tic
// tac toe board
////////////////////////////////////////////////////////////////////////////////
main() {

  const pos00  = const BoardLocation(0, 0);
  const pos10  = const BoardLocation(1, 0);

  group('Whos Turn Is It?:', () {
    test('X is next', () {
      xTurnNext.forEach((boardMatrix) {
        IGameEngine engine = new BasicGameEngine.fromMatrix(boardMatrix);
        expect(engine.nextPlayer, equals(Player.PLAYER_X));
        IGameEngine swappedEngine = 
          new BasicGameEngine.fromMatrix(swapPlayers(boardMatrix),
                                         Player.PLAYER_O);
        expect(swappedEngine.nextPlayer, equals(Player.PLAYER_O));
      });
    });
  });

  group('Basic Engine Move Correctness:', () {
    test('X Goes First', () {
      IGameEngine gameEngine = new BasicGameEngine();
      expect(gameEngine.positionState(pos00), equals(PositionState.EMPTY));
      gameEngine.makeMove(new PlayerMove(Player.PLAYER_X, pos00));
      expect(gameEngine.positionState(pos00), equals(PositionState.HAS_X));
    });

    test('X Goes First Exception', () {
      IGameEngine gameEngine = new BasicGameEngine(Player.PLAYER_O);
      try {
        gameEngine.makeMove(new PlayerMove(Player.PLAYER_X, pos00));
      } on InvalidMove catch(invalidMove) {
        expect(invalidMove.reason, equals(InvalidMoveReason.OUT_OF_TURN));
        return;
      }
      assert(null == "Excpected InvalidMove");
    });

    test('X Moves To Filled Position Exception', () {
      IGameEngine gameEngine = new BasicGameEngine();
      gameEngine.makeMove(new PlayerMove(Player.PLAYER_X, pos00));
      gameEngine.makeMove(new PlayerMove(Player.PLAYER_O, pos10));
      try {
        gameEngine.makeMove(new PlayerMove(Player.PLAYER_X, pos00));
      } on InvalidMove catch(invalidMove) {
        expect(invalidMove.reason, equals(InvalidMoveReason.BAD_LOCATION));
        return;
      }
      assert(null == "Excpected InvalidMove");
    });

    test('X Moves On Game Over Exception', () {
      IGameEngine gameEngine = 
        new BasicGameEngine.fromMatrix(xWins['horizontal_0']);
      try {
        gameEngine.makeMove(new PlayerMove(Player.PLAYER_O, pos00));
      } on InvalidMove catch(invalidMove) {
        expect(invalidMove.reason, equals(InvalidMoveReason.GAME_OVER));
        return;
      }
      assert(null == "Excpected InvalidMove");
    });

    test('Games end in CAT', () {
      xTurnNext.forEach((boardMatrix) {
        IGameEngine engine = new BasicGameEngine.fromMatrix(boardMatrix);
        while(!engine.isGameOver)
          engine.engineMove();
        expect(engine.isCatGame, equals(true));
      });
    });


  });

}