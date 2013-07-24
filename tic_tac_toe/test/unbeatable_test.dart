import 'package:unittest/unittest.dart';
import 'package:tic_tac_toe/engine.dart';
import "package:logging/logging.dart";
import "package:logging_handlers/logging_handlers_shared.dart";
import 'input_games.dart';


/// This shows that if a human is X and X goes first, no matter where X goes the
/// computer will win. This does not show the computer is unbeatable in any
/// circumstance, just over the set of games that are started from scratch.
main() {

  final _logger = new Logger("Unbeatable");
  Logger.root.onRecord.listen(new PrintHandler());

  var computer = Player.PLAYER_O;
  var human = Player.PLAYER_X;

  void allCombinations(IGameEngine engine) {
    // First use engine to move for o
    var computerMove = engine.engineMove();
    _logger.info("Computer Moved: $computerMove\n$engine");

    if(engine.playerHasWon(computer)) {
      _logger.info("Computer Won: $engine");
    } else if(!engine.isGameOver) {
      engine.potentialMoves.forEach((location) {
        var humanMove = engine.createMove(location);
        engine.makeMove(humanMove);
        _logger.info("Human Moved: $humanMove\n$engine");
        if(engine.playerHasWon(human)) {
          throw 'Found losing game $engine';
        } else if(engine.isCatGame) {
          _logger.info("Ended CAT:\n${engine}");
        } else {
          allCombinations(engine);
        }
        engine.undoMove(humanMove);
      });
    }

    engine.undoMove(computerMove);
  }

  IGameEngine engine = new BasicGameEngine.fromMatrix(emptyGame);
  int dim = emptyGame.length;
  for(int row = 0; row < dim; row++) {
    for(int col = 0; col < dim; col++) {
      var humanFirstMove = engine.createMove(new BoardLocation(row, col));
      engine.makeMove(humanFirstMove);
      _logger.info("Human Gamit: $humanFirstMove\n$engine");
      test('Human Gamit: $humanFirstMove', () =>
          expect(() => allCombinations(engine), returnsNormally));
      engine.undoMove(humanFirstMove);
    }
  }

  assert(engine.emptySlots == dim*dim);
}