library tic_tac_toe.tic_tac_toe;

import 'package:logging/logging.dart';
// custom <additional imports>
// end <additional imports>

part 'src/tic_tac_toe/exception.dart';
part 'src/tic_tac_toe/tic_tac_toe.dart';
part 'src/tic_tac_toe/engine.dart';

final _logger = new Logger('tic_tac_toe');

/// Reason for move failing
class InvalidMoveReason implements Comparable<InvalidMoveReason> {
  static const BAD_LOCATION = const InvalidMoveReason._(0);
  static const OUT_OF_TURN = const InvalidMoveReason._(1);
  static const GAME_OVER = const InvalidMoveReason._(2);

  static get values => [
    BAD_LOCATION,
    OUT_OF_TURN,
    GAME_OVER
  ];

  final int value;

  int get hashCode => value;

  const InvalidMoveReason._(this.value);

  copy() => this;

  int compareTo(InvalidMoveReason other) => value.compareTo(other.value);

  String toString() {
    switch(this) {
      case BAD_LOCATION: return "BadLocation";
      case OUT_OF_TURN: return "OutOfTurn";
      case GAME_OVER: return "GameOver";
    }
    return null;
  }

  static InvalidMoveReason fromString(String s) {
    if(s == null) return null;
    switch(s) {
      case "BadLocation": return BAD_LOCATION;
      case "OutOfTurn": return OUT_OF_TURN;
      case "GameOver": return GAME_OVER;
      default: return null;
    }
  }

}

class Player implements Comparable<Player> {
  static const PLAYER_X = const Player._(0);
  static const PLAYER_O = const Player._(1);

  static get values => [
    PLAYER_X,
    PLAYER_O
  ];

  final int value;

  int get hashCode => value;

  const Player._(this.value);

  copy() => this;

  int compareTo(Player other) => value.compareTo(other.value);

  String toString() {
    switch(this) {
      case PLAYER_X: return "PlayerX";
      case PLAYER_O: return "PlayerO";
    }
    return null;
  }

  static Player fromString(String s) {
    if(s == null) return null;
    switch(s) {
      case "PlayerX": return PLAYER_X;
      case "PlayerO": return PLAYER_O;
      default: return null;
    }
  }

  // custom <enum Player>

  Player get opponent => (this == PLAYER_X) ?
    PLAYER_O : PLAYER_X;

  // end <enum Player>
}

class PositionState implements Comparable<PositionState> {
  static const HAS_X = const PositionState._(0);
  static const HAS_O = const PositionState._(1);
  static const EMPTY = const PositionState._(2);

  static get values => [
    HAS_X,
    HAS_O,
    EMPTY
  ];

  final int value;

  int get hashCode => value;

  const PositionState._(this.value);

  copy() => this;

  int compareTo(PositionState other) => value.compareTo(other.value);

  String toString() {
    switch(this) {
      case HAS_X: return "HasX";
      case HAS_O: return "HasO";
      case EMPTY: return "Empty";
    }
    return null;
  }

  static PositionState fromString(String s) {
    if(s == null) return null;
    switch(s) {
      case "HasX": return HAS_X;
      case "HasO": return HAS_O;
      case "Empty": return EMPTY;
      default: return null;
    }
  }

}

/// 
/// Has x won, has y won, is the game incomplete, or is it
/// complete with no winner (a CAT game).  This is a mutually
/// exclusive state.
///
/// An incomplete game might be considered a CAT game if one
/// assumed two intelligent players will definitely end it in
/// a draw, but that is still an INCOMPLETE game as opposed
/// to CAT, since CAT state means the board is filled.
///
/// 
class GameState implements Comparable<GameState> {
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

  int get hashCode => value;

  const GameState._(this.value);

  copy() => this;

  int compareTo(GameState other) => value.compareTo(other.value);

  String toString() {
    switch(this) {
      case X_WON: return "XWon";
      case O_WON: return "OWon";
      case INCOMPLETE: return "Incomplete";
      case CAT_GAME: return "CatGame";
    }
    return null;
  }

  static GameState fromString(String s) {
    if(s == null) return null;
    switch(s) {
      case "XWon": return X_WON;
      case "OWon": return O_WON;
      case "Incomplete": return INCOMPLETE;
      case "CatGame": return CAT_GAME;
      default: return null;
    }
  }

}

// custom <library tic_tac_toe>
// end <library tic_tac_toe>
