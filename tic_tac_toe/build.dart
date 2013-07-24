import "dart:io";
import "package:polymer/component_build.dart";

main() {
  build(new Options().arguments, 
    [
      "example/basic_game/basic_game.html"
    ]);
}
