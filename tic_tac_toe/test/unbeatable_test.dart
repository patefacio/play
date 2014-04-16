import 'package:unittest/unittest.dart';
import 'package:tic_tac_toe/tic_tac_toe.dart';
import "package:logging/logging.dart";
import 'dart:convert' as convert;
import 'input_games.dart';

////////////////////////////////////////////////////////////////////////////////
// This shows that if a human is X and X goes first, no matter where X goes the
// computer will win. This does not show the computer is unbeatable in under
// any circumstance, just over the set of games that are started from
// scratch. The IGameEngine interface was designed to accept any valid game, so
// a larger test would be - /For any valid board state in which X just moved/
// ensure O will not lose. This would include board states in which the
// computer performed a bad move, which is not tested below.
////////////////////////////////////////////////////////////////////////////////
main() {

  final _logger = new Logger("Unbeatable");

  group('Brute Force Testing', () {

    int totalHumanMovesEvaluated = 0;

    // Use this when logging desired this set of tests
    if(false) {
      Logger.root.level = Level.FINE;
      Logger.root.onRecord.listen((LogRecord r) =>
          print("${r.loggerName} [${r.level}]:\t${r.message}"));
    }

    var computer = Player.PLAYER_O;
    var human = Player.PLAYER_X;

    // Function that tries out all of the potential human moves against the next
    // computer move. If the computer ever loses an exception is thrown and the
    // test will fail
    void allCombinations(IGameEngine engine) {
      // First use engine to move for o
      var computerMove = engine.engineMove();
      _logger.finer("Computer Moved: $computerMove\n$engine");

      if(engine.playerHasWon(computer)) {
        _logger.finer("Computer Won: $engine");
      } else if(!engine.isGameOver) {
        engine.potentialMoves.forEach((location) {
          var humanMove = engine.createMove(location);
          engine.makeMove(humanMove);
          totalHumanMovesEvaluated++;
          _logger.finer("Human Moved: $humanMove\n$engine");
          if(engine.playerHasWon(human)) {
            throw 'Found losing game $engine';
          } else if(engine.isCatGame) {
            _logger.finer("Ended CAT:\n${engine}");
          } else {
            allCombinations(engine);
          }
          engine.undoMove(humanMove);
        });
      }

      engine.undoMove(computerMove);
    }

    int dim = emptyGame.length;

    // For each potential first human move (X), create a game engine and play
    // out computer moves against all possible human moves
    for(int row = 0; row < dim; row++) {
      for(int col = 0; col < dim; col++) {
        IGameEngine engine = new BasicGameEngine.fromMatrix(emptyGame);

        var humanFirstMove = engine.createMove(new BoardLocation(row, col));
        engine.makeMove(humanFirstMove);
        totalHumanMovesEvaluated++;
        _logger.finer("Human Gambit: $humanFirstMove\n$engine");
        test('Human Gambit: $humanFirstMove', () {
          expect(() => allCombinations(engine), returnsNormally);
          _logger.fine("Completed with $totalHumanMovesEvaluated human moves");
        });
        engine.undoMove(humanFirstMove);

        // All move/undo combinations must add up and result in original empty
        // game
        assert(engine.emptySlots == dim*dim);
      }
    }
  });

}
