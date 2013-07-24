import 'dart:io';
import 'package:tic_tac_toe/tic_tac_toe.dart';

////////////////////////////////////////////////////////////////////////////////
// Basic loop allowig user to play the computer. User starts off first as player
// X. Note: this must be run in non-checked mode since readLineSync causes
// issues in checked.
////////////////////////////////////////////////////////////////////////////////
main() {
  IGameEngine engine = new BasicGameEngine();

  print("You are player X - let's begin\n");
  while(!engine.isGameOver) {
    print("The board is: $engine");
    print("Enter move as number 1 through 9");
    String line = stdin.readLineSync();
    try {
      int move = int.parse(line) - 1;
      var location = new BoardLocation((move/3).floor(), move%3);
      var playerMove = new PlayerMove(Player.PLAYER_X, location);

      engine.makeMove(playerMove);
      print("You wanted move: $playerMove");
      print(engine);

      if(engine.isGameOver) {
        print("Game over: $engine");
        return;
      }

      var myMove = engine.nextMove();
      print("I chose move: $myMove");
      engine.makeMove(myMove);

      if(engine.isGameOver) {
        print("Game over: $engine");
      }

      print("------------------------------------------------");
    } catch(e) {
      print("OOPS - Exception $e\n"
          "Pls enter number between 1 and 9 - try again");
    }
  }
}