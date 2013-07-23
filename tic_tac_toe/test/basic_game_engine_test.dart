import 'package:unittest/unittest.dart';
import 'package:tic_tac_toe/engine.dart';

List<List<PositionState>> _transpose(List<List<PositionState>> original) {
  final int dim = original.length;
  List<List<PositionState>> result = new List<List<PositionState>>(dim);
  for(int row = 0; row < dim; row++) {
    result[row] = new List<PositionState>(dim);
    for(int col = 0; col < dim; col++) {
      result[row][col] = original[col][row];
    }
  }
  return result;
}

main() {
  final List<List<PositionState>> horWinMat1 =         
    [
      [ PositionState.HAS_X, PositionState.HAS_X, PositionState.HAS_X, ],
      [ PositionState.EMPTY, PositionState.HAS_O, PositionState.HAS_O, ],
      [ PositionState.HAS_O, PositionState.EMPTY, PositionState.HAS_X, ],
    ];

  final List<List<PositionState>> horWinMat2 =         
    [
      [ PositionState.HAS_O, PositionState.EMPTY, PositionState.HAS_X, ],
      [ PositionState.EMPTY, PositionState.HAS_O, PositionState.HAS_O, ],
      [ PositionState.HAS_X, PositionState.HAS_X, PositionState.HAS_X, ],
    ];
    
  final List<List<PositionState>> horWinMat3 =
    [
      [ PositionState.HAS_O, PositionState.EMPTY, PositionState.HAS_X, ],
      [ PositionState.HAS_X, PositionState.HAS_X, PositionState.HAS_X, ],
      [ PositionState.EMPTY, PositionState.HAS_O, PositionState.HAS_O, ],
    ];

  group('Basic Board Tests', () {

    IBoard horizontalWin1 = new Board.fromMatrix(horWinMat1);
    IBoard horizontalWin2 = new Board.fromMatrix(horWinMat2);
    IBoard horizontalWin3 = new Board.fromMatrix(horWinMat3);

    Map horizontals = { 
      'H1' : horizontalWin1,
      'H2' : horizontalWin2,
      'H3' : horizontalWin3
    };

    horizontals.forEach((tag, board) {
      test('$tag: X Wins', () =>
          expect(board.horizontalWinner(Player.PLAYER_X),
              equals(true)));

      test('$tag: O Does Not Win', () =>
          expect(board.horizontalWinner(Player.PLAYER_O),
              equals(false)));
    });

    IBoard verticalWin1 = new Board.fromMatrix(_transpose(horWinMat1));
    IBoard verticalWin2 = new Board.fromMatrix(_transpose(horWinMat2));
    IBoard verticalWin3 = new Board.fromMatrix(_transpose(horWinMat3));

    Map verticals = {
      'V1' : verticalWin1,
      'V2' : verticalWin2,
      'V3' : verticalWin3,
    };

    verticals.forEach((tag, board) {
      test('$tag: X Wins', () =>
          expect(board.verticalWinner(Player.PLAYER_X),
              equals(true)));

      test('$tag: O Does Not Win', () =>
          expect(board.verticalWinner(Player.PLAYER_O),
              equals(false)));
    });

    List<List<PositionState>> backDiagWinMat =         
      [
        [ PositionState.HAS_X, PositionState.HAS_O, PositionState.HAS_X, ],
        [ PositionState.EMPTY, PositionState.HAS_X, PositionState.HAS_O, ],
        [ PositionState.HAS_O, PositionState.EMPTY, PositionState.HAS_X, ],
      ];

    List<List<PositionState>> forwardDiagWinMat =         
      [
        [ PositionState.HAS_O, PositionState.HAS_O, PositionState.HAS_X, ],
        [ PositionState.EMPTY, PositionState.HAS_X, PositionState.HAS_O, ],
        [ PositionState.HAS_X, PositionState.EMPTY, PositionState.HAS_X, ],
      ];

    IBoard forwardDiagWin = new Board.fromMatrix(forwardDiagWinMat);
    IBoard backDiagWin = new Board.fromMatrix(backDiagWinMat);

    test('Forward Diag: X Wins', () =>
          expect(forwardDiagWin.forwardDiagonalWinner(Player.PLAYER_X),
              equals(true)));

    test('Forward Diag: O Does Not Win', () =>
          expect(forwardDiagWin.forwardDiagonalWinner(Player.PLAYER_O),
              equals(false)));

    test('Back Diag: X Wins', () =>
          expect(backDiagWin.backDiagonalWinner(Player.PLAYER_X),
              equals(true)));

    test('Back Diag: O Does Not Win', () =>
          expect(backDiagWin.backDiagonalWinner(Player.PLAYER_O),
              equals(false)));

    List xWinningBoards = [ 
      horizontalWin1, horizontalWin2, horizontalWin3,
      verticalWin1, verticalWin2, verticalWin3,
      forwardDiagWin, backDiagWin
    ];

    test('playerHasWon X: true', () =>
        xWinningBoards.forEach((xWins) =>
            expect(xWins.playerHasWon(Player.PLAYER_X), equals(true))));

    test('playerHasWon O: false', () =>
        xWinningBoards.forEach((xWins) =>
            expect(xWins.playerHasWon(Player.PLAYER_O), equals(false))));

    test('xHasWon: true', () =>
        xWinningBoards.forEach((xWins) =>
            expect(xWins.xHasWon, equals(true))));

    test('oHasWon: false', () =>
        xWinningBoards.forEach((xWins) =>
            expect(xWins.oHasWon, equals(false))));
        
  });

  group('Basic Engine Move Tests', () {
    test('X Goes First', () {
      IGameEngine gameEngine = new BasicGameEngine();
      expect(gameEngine.positionState(0,0), equals(PositionState.EMPTY));
      gameEngine.move(new PlayerMove(Player.PLAYER_X, 0, 0));
      expect(gameEngine.positionState(0,0), equals(PositionState.HAS_X));
    });

    test('X Goes First Exception', () {
      IGameEngine gameEngine = new BasicGameEngine(Player.PLAYER_O);
      try {
        gameEngine.move(new PlayerMove(Player.PLAYER_X, 0, 0));
      } on InvalidMove catch(invalidMove) {
        expect(invalidMove.reason, equals(InvalidMoveReason.OUT_OF_TURN));
        return;
      }
      assert(null == "Excpected InvalidMove");
    });

    test('X Moves To Filled Position Exception', () {
      IGameEngine gameEngine = new BasicGameEngine();
      gameEngine.move(new PlayerMove(Player.PLAYER_X, 0, 0));
      gameEngine.move(new PlayerMove(Player.PLAYER_O, 1, 0));
      try {
        gameEngine.move(new PlayerMove(Player.PLAYER_X, 0, 0));
      } on InvalidMove catch(invalidMove) {
        expect(invalidMove.reason, equals(InvalidMoveReason.BAD_LOCATION));
        return;
      }
      assert(null == "Excpected InvalidMove");
    });

    test('X Moves On Game Over Exception', () {
      IGameEngine gameEngine = new BasicGameEngine.fromMatrix(horWinMat1);
      try {
        gameEngine.move(new PlayerMove(Player.PLAYER_O, 0, 0));
      } on InvalidMove catch(invalidMove) {
        expect(invalidMove.reason, equals(InvalidMoveReason.GAME_OVER));
        return;
      }
      assert(null == "Excpected InvalidMove");
    });

  });

}