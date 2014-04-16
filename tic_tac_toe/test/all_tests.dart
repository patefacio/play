import 'basic_game_engine_test.dart' as bget;
import 'basic_board_tests.dart' as board;
import 'unbeatable_test.dart' as unbeatable;
import "package:logging/logging.dart";

main() {
  Logger.root.onRecord.listen((LogRecord r) =>
      print("${r.loggerName} [${r.level}]:\t${r.message}"));
  Logger.root.level = Level.FINE;
  bget.main();
  board.main();
  unbeatable.main();
}