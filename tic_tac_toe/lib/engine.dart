library engine;

import "package:logging/logging.dart";
import "package:logging_handlers/logging_handlers_shared.dart";
part "src/engine/engine.dart";

final _logger = new Logger("engine");

/// Reason for move failing
class InvalidMoveReason { 
  static const BAD_LOCATION = const InvalidMoveReason._(0);
  static const OUT_OF_TURN = const InvalidMoveReason._(1);
  static const GAME_OVER = const InvalidMoveReason._(2);

  static get values => [
    BAD_LOCATION,
    OUT_OF_TURN,
    GAME_OVER
  ];

  final int value;

  const InvalidMoveReason._(this.value);

  String toString() { 
    switch(this) { 
      case BAD_LOCATION: return "BAD_LOCATION";
      case OUT_OF_TURN: return "OUT_OF_TURN";
      case GAME_OVER: return "GAME_OVER";
    }
  }

  static InvalidMoveReason fromString(String s) { 
    switch(s) { 
      case "BAD_LOCATION": return BAD_LOCATION;
      case "OUT_OF_TURN": return OUT_OF_TURN;
      case "GAME_OVER": return GAME_OVER;
    }
  }


}

/// Player x or player o - mutually exclusive
class Player { 
  static const PLAYER_X = const Player._(0);
  static const PLAYER_O = const Player._(1);

  static get values => [
    PLAYER_X,
    PLAYER_O
  ];

  final int value;

  const Player._(this.value);

  String toString() { 
    switch(this) { 
      case PLAYER_X: return "PLAYER_X";
      case PLAYER_O: return "PLAYER_O";
    }
  }

  static Player fromString(String s) { 
    switch(s) { 
      case "PLAYER_X": return PLAYER_X;
      case "PLAYER_O": return PLAYER_O;
    }
  }


  // custom <enum Player>

  Player get opponent => (this == PLAYER_X) ?
    PLAYER_O : PLAYER_X;

  // end <enum Player>

}

/// Does the position contain x, o, or nothing
class PositionState { 
  static const HAS_X = const PositionState._(0);
  static const HAS_O = const PositionState._(1);
  static const EMPTY = const PositionState._(2);

  static get values => [
    HAS_X,
    HAS_O,
    EMPTY
  ];

  final int value;

  const PositionState._(this.value);

  String toString() { 
    switch(this) { 
      case HAS_X: return "HAS_X";
      case HAS_O: return "HAS_O";
      case EMPTY: return "EMPTY";
    }
  }

  static PositionState fromString(String s) { 
    switch(s) { 
      case "HAS_X": return HAS_X;
      case "HAS_O": return HAS_O;
      case "EMPTY": return EMPTY;
    }
  }


}

/// Has x won, has y won, is the game incomplete, or is it complete with no winner
/// (a CAT game).  This is a mutually exclusive state. 
/// 
/// An incomplete game might be considered a CAT game if one assumed two intelligent
/// players will definitely end it in a draw, but that is still an INCOMPLETE game
/// as opposed to CAT, since CAT state means the board is filled.
/// 
class GameState { 
  static const X_WON = const GameState._(0);
  static const O_WON = const GameState._(1);
  static const INCOMPLETE = const GameState._(2);
  static const CAT_GAME = const GameState._(3);

  static get values => [
    X_WON,
    O_WON,
    INCOMPLETE,
    CAT_GAME
  ];

  final int value;

  const GameState._(this.value);

  String toString() { 
    switch(this) { 
      case X_WON: return "X_WON";
      case O_WON: return "O_WON";
      case INCOMPLETE: return "INCOMPLETE";
      case CAT_GAME: return "CAT_GAME";
    }
  }

  static GameState fromString(String s) { 
    switch(s) { 
      case "X_WON": return X_WON;
      case "O_WON": return O_WON;
      case "INCOMPLETE": return INCOMPLETE;
      case "CAT_GAME": return CAT_GAME;
    }
  }


}

/// Win, lose or draw - from the perspective of one or other user
class Outcome { 
  static const WIN = const Outcome._(0);
  static const LOSE = const Outcome._(1);
  static const DRAW = const Outcome._(2);

  static get values => [
    WIN,
    LOSE,
    DRAW
  ];

  final int value;

  const Outcome._(this.value);

  String toString() { 
    switch(this) { 
      case WIN: return "WIN";
      case LOSE: return "LOSE";
      case DRAW: return "DRAW";
    }
  }

  static Outcome fromString(String s) { 
    switch(s) { 
      case "WIN": return WIN;
      case "LOSE": return LOSE;
      case "DRAW": return DRAW;
    }
  }


}

// custom <library engine>
// end <library engine>

