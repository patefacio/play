part of tic_tac_toe;

/// Indicates an call to undoMove, which can happen when the
/// [move] requested undone is not present on the board.
class InvalidUndoOperation implements Exception {

  InvalidUndoOperation(this.message);

  String message;

  // custom <class InvalidUndoOperation>

  String toString() => 'InvalidUndoOperation: $message';

  // end <class InvalidUndoOperation>
}

/// Board is in invalid state.  This can be caused by
/// providing an invalid board matrix, for example if there
/// are too many X or Os or if [whoMovesNext] is provided and
/// not a valid option. Message contains information about
/// the cause.
class InvalidBoard implements Exception {

  InvalidBoard(this.message);

  String message;

  // custom <class InvalidBoard>

  String toString() => 'InvalidBoard: $message';

  // end <class InvalidBoard>
}

/// Exception indicating move to location already filled
class InvalidMove implements Exception {

  InvalidMove(this.playerMove, this.reason);

  PlayerMove playerMove;
  InvalidMoveReason reason;

  // custom <class InvalidMove>

  String toString() => 'InvalidMove: ${playerMove} reason => $reason';

  // end <class InvalidMove>
}
// custom <part exception>
// end <part exception>

