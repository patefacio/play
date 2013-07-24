import 'basic_game_engine_test.dart' as bget;
import 'basic_board_tests.dart' as board;
import 'unbeatable_test.dart' as unbeatable;
import "package:logging/logging.dart";
import "package:logging_handlers/logging_handlers_shared.dart";

main() {
  Logger.root.onRecord.listen(new PrintHandler());
  Logger.root.level = Level.FINE;
  bget.main();
  board.main();
  unbeatable.main();
}