import "dart:io";
import "package:ebisu/ebisu_dart_meta.dart";
import "package:ebisu_web_ui/ebisu_web_ui.dart";
import "package:pathos/path.dart" as path;

main() {
  Options options = new Options();
  String here = path.dirname(path.absolute(options.script));
  String rootDir = "${here}/../..";
  String ticTacToeDir = "${rootDir}/tic_tac_toe";

  ComponentLibrary lib = componentLibrary('tic_tac_toe')
    ..doc = 'Simple tic tac toe game'
    ..rootPath = rootDir
    ..dependencies = [
      pubdep('split_panel')
      ..gitRef = 'HEAD'
      ..path = 'git://github.com/patefacio/split_panel',
    ]
    ..examples = [
      example(id('basic_game'))
    ]
    ..components = [
      component('tic_tac_toe')
    ]
    ..libraries = [
      library('tic_tac_toe')
      ..imports = [
      ]
      ..includeLogger = true
      ..enums = [
        enum_('invalid_move_reason')
        ..doc = 'Reason for move failing'
        ..values = [ 
          id('bad_location'),
          id('out_of_turn'),
          id('game_over'),
        ],
        enum_('player')
        ..hasCustom = true
        ..values = [ id('player_x'), id('player_o')],
        enum_('position_state')
        ..values = [ id('has_x'), id('has_o'), id('empty')],
        enum_('game_state')
        ..doc = '''

Has x won, has y won, is the game incomplete, or is it
complete with no winner (a CAT game).  This is a mutually
exclusive state.

An incomplete game might be considered a CAT game if one
assumed two intelligent players will definitely end it in
a draw, but that is still an INCOMPLETE game as opposed
to CAT, since CAT state means the board is filled.

'''
        ..values = [ 
          id('x_won'), id('o_won'), id('incomplete'),
          id('cat_game'),
        ],
      ]
      ..parts = [
        part('exception')
        ..classes = [
          class_('invalid_undo_operation')
          ..doc = '''
Indicates an call to undoMove, which can happen when the
[move] requested undone is not present on the board.'''

          ..implement = ['Exception']
          ..members = [
            member('message')
            ..ctors = [''],
          ],
          class_('invalid_board')
          ..implement = ['Exception']
          ..doc = '''
Board is in invalid state.  This can be caused by
providing an invalid board matrix, for example if there
are too many X or Os or if [whoMovesNext] is provided and
not a valid option. Message contains information about
the cause.'''
          ..members = [
            member('message')
            ..ctors = [''],
          ],
          class_('invalid_move')
          ..doc = 'Exception indicating move to location already filled'
          ..implement = ['Exception']
          ..members = [
            member('player_move')
            ..type = 'PlayerMove'
            ..ctors = [''],
            member('reason')
            ..type = 'InvalidMoveReason'
            ..ctors = [''],
          ],
        ],
        part('tic_tac_toe')
        ..classes = [
          class_('board_location')
          ..doc = 'Row and column indentifying location on board'
          ..ctorConst = ['']
          ..members = [
            member('row')
            ..type = 'int'
            ..isFinal = true
            ..ctors = [''],
            member('column')
            ..type = 'int'
            ..isFinal = true
            ..ctors = [''],
          ],
          class_('player_move')
          ..doc = 'Indicates a move of player to specified location'
          ..ctorConst = ['']
          ..members = [
            member('player')
            ..type = 'Player'
            ..isFinal = true
            ..ctors = [''],
            member('location')
            ..type = 'BoardLocation'
            ..isFinal = true
            ..ctors = [''],
          ],
          class_('i_board')
          ..doc = 'Interface to a tic-tac-toe board'
          ..isAbstract = true,
          class_('i_game_engine')
          ..doc = '''

Interface to the game play engine. The engine can automate a move for
*either* player via [engineMove]. Alternatively, the interface
supports non-automated moves via [makeMove].

'''
          ..isAbstract = true,
        ],
        part('engine')
        ..classes = [
          class_('state_counts')
          ..doc = 'Accumulation of counts of the three possible states on a board'
          ..members = [
            member('x_count')
            ..type = 'int'
            ..classInit = '0',
            member('o_count')
            ..type = 'int'
            ..classInit = '0',
            member('empty_count')
            ..classInit = '0'
            ..type = 'int',
          ],
          class_('board')
          ..defaultMemberAccess = IA
          ..ctorCustoms = ['']
          ..extend = 'IBoard'
          ..members = [
            member('game_dim')
            ..type = 'int'
            ..isFinal = true
            ..access = RO
            ..ctorInit = '3'
            ..ctorsOpt = [''],
            member('position_states')
            ..type = 'List<List<PositionState>>',
            member('game_state')
            ..access = RO
            ..type = 'GameState',
            member('empty_slots')
            ..doc = 'Number of slots that are currently empty'
            ..access = RO
            ..type = 'int'
          ],          
          class_('basic_game_engine')
          ..defaultMemberAccess = IA
          ..doc = '''

A basic engine that provides an automated move [nextMove]
that will seek at least a draw, but not necessarily
aggressively go for the win.

'''
          ..extend = 'IGameEngine'
          ..members = [
            member('board')
            ..type = 'Board'
            ..classInit = 'new Board()',
            member('next_player')
            ..doc = 'X goes first by default'
            ..access = RO
            ..type = 'Player'
            ..ctorInit = 'Player.PLAYER_X'
            ..ctorsOpt = [''],
          ]
        ]
      ]
    ];

  lib.generate();
}