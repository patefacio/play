library tic_tac_toe;
import 'dart:html';
import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';

final _logger = new Logger("ticTacToe");

@CustomTag("tic-tac-toe")
class TicTacToe extends PolymerElement {


  TicTacToe.created() : super.created() {
    // custom <TicTacToe created>
    // end <TicTacToe created>
  }

  // custom <class TicTacToe>
  void inserted() {
    style.height = "500px";
    style.width = "500px";
    print("${getComputedStyle().height}");
    print("TTT inserted");
  }
  // end <class TicTacToe>
}




// custom <tic_tac_toe>
// end <tic_tac_toe>
