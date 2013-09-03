import "dart:html";
import "package:polymer/polymer.dart";
import "package:logging/logging.dart";


final _logger = new Logger("ticTacToe");

@CustomTag("tic-tac-toe")
class TicTacToe extends PolymerElement {

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

