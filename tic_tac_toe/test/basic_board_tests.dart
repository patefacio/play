import 'package:unittest/unittest.dart';
import 'package:tic_tac_toe/tic_tac_toe.dart';
import 'input_games.dart';

////////////////////////////////////////////////////////////////////////////////
// Tests to ensure the basics of the tic tac toe board work
////////////////////////////////////////////////////////////////////////////////
main() {

  group('Basic Board Categorization Tests', () {

    xWins.forEach((tag, boardMatrix) {
      IBoard board = new Board.fromMatrix(boardMatrix);
      test('$tag: X Wins', () {
        expect(board.xHasWon, true);
        expect(board.oHasWon, false);
        expect(board.isGameOver, true);
        expect(board.isCatGame, false);
        expect(board.playerHasWon(Player.PLAYER_X), true);
        expect(board.gameState, GameState.X_WON);
        expect(board.gameDim, 3);
      });

      IBoard swapped = new Board.fromMatrix(swapPlayers(boardMatrix));
      test('swapped $tag: O Wins', () {
        expect(swapped.xHasWon, false);
        expect(swapped.oHasWon, true);
        expect(swapped.isGameOver, true);
        expect(swapped.isCatGame, false);
        expect(swapped.playerHasWon(Player.PLAYER_O), true);
        expect(swapped.xHasWon, false);
        expect(swapped.gameState, GameState.O_WON);
      });
    });

    incompleteGames.forEach((boardMatrix) {
      IBoard board = new Board.fromMatrix(boardMatrix);
      test('incomplete games are incomplete', () =>
          expect(board.gameState, GameState.INCOMPLETE));

      test('potential moves count matches emptySlots', () {
        expect((board as Board).emptySlots, 
            board.potentialMoves.length);
      });
          
    });

    catGames.forEach((boardMatrix) {
      IBoard board = new Board.fromMatrix(boardMatrix);
      test('cat games are complete', () =>
          expect(board.gameState, GameState.CAT_GAME));
      test('cat games have no potential moves', () =>
          expect(board.potentialMoves.length == 0, true));
    });

    horizontalXWins.forEach((tag, boardMatrix) {
      Board board = new Board.fromMatrix(boardMatrix);
      test('$tag: X Wins', () =>
          expect(board.horizontalWinner(Player.PLAYER_X), true));
    });

    verticalXWins.forEach((tag, boardMatrix) {
      Board board = new Board.fromMatrix(boardMatrix);
      test('$tag: X Wins', () =>
          expect(board.verticalWinner(Player.PLAYER_X), true));
    });

    diagonalXWins.forEach((tag, boardMatrix) {
      Board board = new Board.fromMatrix(boardMatrix);
      test('$tag: X Wins', () =>
          expect(board.forwardDiagonalWinner(Player.PLAYER_X) ||
              board.backDiagonalWinner(Player.PLAYER_X), true));
    });

    test('Board Reset', () {
      IGameEngine engine = 
        new BasicGameEngine.fromMatrix(horizontalXWins['horizontal_0']);
      expect(engine.emptySlots, 2);
      expect(engine.nextPlayer, isNull);
      engine.startNewGame(Player.PLAYER_O);
      expect(engine.emptySlots, engine.gameDim * engine.gameDim);
      expect(engine.nextPlayer, Player.PLAYER_O);
      engine.startNewGame();
      expect(engine.nextPlayer, Player.PLAYER_X);
      engine.startNewGame(Player.PLAYER_X);
      expect(engine.nextPlayer, Player.PLAYER_X);
    });

  });


}