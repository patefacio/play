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
        expect(board.xHasWon, equals(true));
        expect(board.isGameOver, equals(true));
        expect(board.oHasWon, equals(false));
        expect(board.gameState, equals(GameState.X_WON));
      });

      IBoard swapped = new Board.fromMatrix(swapPlayers(boardMatrix));
      test('swapped $tag: O Wins', () {
        expect(swapped.oHasWon, equals(true));
        expect(swapped.isGameOver, equals(true));
        expect(swapped.xHasWon, equals(false));
        expect(swapped.gameState, equals(GameState.O_WON));
      });
    });

    incompleteGames.forEach((boardMatrix) {
      IBoard board = new Board.fromMatrix(boardMatrix);
      test('incomplete games are incomplete', () =>
          expect(board.gameState, equals(GameState.INCOMPLETE)));

      test('potential moves count matches emptySlots', () {
        expect((board as Board).emptySlots, 
            equals(board.potentialMoves.length));
      });
          
    });

    catGames.forEach((boardMatrix) {
      IBoard board = new Board.fromMatrix(boardMatrix);
      test('cat games are complete', () =>
          expect(board.gameState, equals(GameState.CAT_GAME)));
      test('cat games have no potential moves', () =>
          expect(board.potentialMoves.length == 0, equals(true)));
    });

    horizontalXWins.forEach((tag, boardMatrix) {
      Board board = new Board.fromMatrix(boardMatrix);
      test('$tag: X Wins', () =>
          expect(board.horizontalWinner(Player.PLAYER_X),
              equals(true)));
    });

    verticalXWins.forEach((tag, boardMatrix) {
      Board board = new Board.fromMatrix(boardMatrix);
      test('$tag: X Wins', () =>
          expect(board.verticalWinner(Player.PLAYER_X),
              equals(true)));
    });

    diagonalXWins.forEach((tag, boardMatrix) {
      Board board = new Board.fromMatrix(boardMatrix);
      test('$tag: X Wins', () =>
          expect(board.forwardDiagonalWinner(Player.PLAYER_X) ||
              board.backDiagonalWinner(Player.PLAYER_X),
              equals(true)));
    });

  });


}