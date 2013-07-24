import 'package:tic_tac_toe/tic_tac_toe.dart';

String boardMatrixToString(List<List<PositionState>> bm) {
  return "\n${bm.join('\n')}";
}

List<List<PositionState>> transpose(List<List<PositionState>> original) {
  final int dim = original.length;
  List<List<PositionState>> result = new List<List<PositionState>>(dim);
  for(int row = 0; row < dim; row++) {
    result[row] = new List<PositionState>(dim);
    for(int col = 0; col < dim; col++) {
      result[row][col] = original[col][row];
    }
  }
  return result;
}

List<List<PositionState>> swapPlayers(List<List<PositionState>> original) {
  final int dim = original.length;
  List<List<PositionState>> result = new List<List<PositionState>>(dim);
  for(int row = 0; row < dim; row++) {
    result[row] = new List<PositionState>(dim);
    for(int col = 0; col < dim; col++) {
      var current = original[col][row];
      if(current == PositionState.EMPTY) {
        result[row][col] = PositionState.EMPTY;
      } else {
        result[row][col] = 
          (current == PositionState.HAS_X)? 
          PositionState.HAS_O : PositionState.HAS_X;
      }
    }
  }
  return result;
}

final horizontalXWins = {
  'horizontal_0' :
  [
    [ PositionState.HAS_X, PositionState.HAS_X, PositionState.HAS_X, ],
    [ PositionState.EMPTY, PositionState.HAS_O, PositionState.HAS_O, ],
    [ PositionState.HAS_O, PositionState.EMPTY, PositionState.HAS_X, ],
  ],
    
  'horizontal_1' :
  [
    [ PositionState.HAS_O, PositionState.EMPTY, PositionState.HAS_X, ],
    [ PositionState.HAS_X, PositionState.HAS_X, PositionState.HAS_X, ],
    [ PositionState.EMPTY, PositionState.HAS_O, PositionState.HAS_O, ],
  ],

  'horizontal_2' :
  [
    [ PositionState.HAS_O, PositionState.EMPTY, PositionState.HAS_X, ],
    [ PositionState.EMPTY, PositionState.HAS_O, PositionState.HAS_O, ],
    [ PositionState.HAS_X, PositionState.HAS_X, PositionState.HAS_X, ],
  ],
};

final diagonalXWins = {
  'forward_diag' :
  [
    [ PositionState.HAS_O, PositionState.HAS_O, PositionState.HAS_X, ],
    [ PositionState.EMPTY, PositionState.HAS_X, PositionState.HAS_O, ],
    [ PositionState.HAS_X, PositionState.EMPTY, PositionState.HAS_X, ],
  ],

  'back_diag' :
  [
    [ PositionState.HAS_X, PositionState.HAS_O, PositionState.HAS_X, ],
    [ PositionState.EMPTY, PositionState.HAS_X, PositionState.HAS_O, ],
    [ PositionState.HAS_O, PositionState.EMPTY, PositionState.HAS_X, ],
  ],
};

final verticalXWins = {
  'vertical_0' : transpose(horizontalXWins['horizontal_0']),
  'vertical_1' : transpose(horizontalXWins['horizontal_1']),
  'vertical_2' : transpose(horizontalXWins['horizontal_2']),
};

final xWins = new Map()
  ..addAll(horizontalXWins)
  ..addAll(diagonalXWins)
  ..addAll(verticalXWins);

final emptyGame = [
    [ PositionState.EMPTY, PositionState.EMPTY, PositionState.EMPTY, ],
    [ PositionState.EMPTY, PositionState.EMPTY, PositionState.EMPTY, ],
    [ PositionState.EMPTY, PositionState.EMPTY, PositionState.EMPTY, ],
];

final xTurnNext = [
  emptyGame,

  [
    [ PositionState.HAS_X, PositionState.EMPTY, PositionState.EMPTY, ],
    [ PositionState.EMPTY, PositionState.HAS_O, PositionState.EMPTY, ],
    [ PositionState.EMPTY, PositionState.EMPTY, PositionState.EMPTY, ],
  ],
  [
    [ PositionState.HAS_X, PositionState.EMPTY, PositionState.EMPTY, ],
    [ PositionState.HAS_X, PositionState.HAS_O, PositionState.EMPTY, ],
    [ PositionState.HAS_O, PositionState.EMPTY, PositionState.EMPTY, ],
  ],
  [
    [ PositionState.HAS_X, PositionState.HAS_O, PositionState.HAS_X, ],
    [ PositionState.HAS_X, PositionState.HAS_O, PositionState.EMPTY, ],
    [ PositionState.HAS_O, PositionState.EMPTY, PositionState.EMPTY, ],
  ],
  [
    [ PositionState.HAS_X, PositionState.HAS_O, PositionState.HAS_X, ],
    [ PositionState.HAS_X, PositionState.HAS_O, PositionState.EMPTY, ],
    [ PositionState.HAS_O, PositionState.HAS_X, PositionState.HAS_O, ],
  ],
];

final incompleteGames = []
  ..addAll(xTurnNext)
  ..addAll(xTurnNext.map((matrix) => swapPlayers(matrix)));

final catGames = [
  [
    [ PositionState.HAS_X, PositionState.HAS_X, PositionState.HAS_O, ],
    [ PositionState.HAS_O, PositionState.HAS_O, PositionState.HAS_X, ],
    [ PositionState.HAS_X, PositionState.HAS_O, PositionState.HAS_X, ],
  ],
  [
    [ PositionState.HAS_X, PositionState.HAS_X, PositionState.HAS_O, ],
    [ PositionState.HAS_O, PositionState.HAS_O, PositionState.HAS_X, ],
    [ PositionState.HAS_X, PositionState.HAS_X, PositionState.HAS_O, ],
  ],
];

final g1 = [
    [ PositionState.HAS_X, PositionState.EMPTY, PositionState.EMPTY, ],
    [ PositionState.EMPTY, PositionState.EMPTY, PositionState.EMPTY, ],
    [ PositionState.EMPTY, PositionState.EMPTY, PositionState.EMPTY, ],
];



