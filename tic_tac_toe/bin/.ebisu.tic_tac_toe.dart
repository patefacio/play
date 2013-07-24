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
    ..examples = [
      example(id('basic_game'))
    ]
    ..components = [
      component('tic_tac_toe_row'),
      component('tic_tac_toe')
    ]
    ..libraries = [
      library('engine')
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
        ..doc = 'Player x or player o - mutually exclusive'
        ..hasCustom = true
        ..values = [ id('player_x'), id('player_o')],
        enum_('position_state')
        ..doc = 'Does the position contain x, o, or nothing'
        ..values = [ id('has_x'), id('has_o'), id('empty')],
        enum_('game_state')
        ..doc = '''
Has x won, has y won, is the game incomplete, or is it complete with no winner
(a CAT game).  This is a mutually exclusive state. 

An incomplete game might be considered a CAT game if one assumed two intelligent
players will definitely end it in a draw, but that is still an INCOMPLETE game
as opposed to CAT, since CAT state means the board is filled.
'''
        ..values = [ 
          id('x_won'), id('o_won'), id('incomplete'),
          id('cat_game'),
        ],
        enum_('outcome')
        ..doc = 'Win, lose or draw - from the perspective of one or other user'
        ..values = [ id('win'), id('lose'), id('draw')],
      ]
      ..parts = [
        part('engine')
        ..classes = [
          class_('invalid_undo')
          ..includeCustom = false
          ..doc = 'Attempted an undo move that does not match move',
          class_('invalid_board')
          ..includeCustom = false
          ..doc = '''Board is in invalid state.  This can be caused by providing an invalid board
matrix, for example if there are too many X or Os or if [whoMovesNext] is
provided and not a valid option.''',
          class_('invalid_move')
          ..doc = 'Exception indicating move to location already filled'
          ..implement = ['Exception']
          ..members = [
            member('player_move')
            ..doc = 'Move that was rejected'
            ..type = 'PlayerMove'
            ..ctors = [''],
            member('reason')
            ..doc = 'Why the move was rejected'
            ..type = 'InvalidMoveReason'
            ..ctors = [''],
          ],
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
          class_('board_location')
          ..doc = 'Row and column indentifying location on board'
          ..ctorConst = ['']
          ..members = [
            member('row')
            ..doc = 'Row for the move'
            ..type = 'int'
            ..isFinal = true
            ..ctors = [''],
            member('column')
            ..doc = 'Column for the move'
            ..type = 'int'
            ..isFinal = true
            ..ctors = [''],
          ],
          class_('player_move')
          ..doc = 'Indicates a move of player to specified location'
          ..ctorConst = ['']
          ..members = [
            member('player')
            ..doc = 'Player (x or o) moving to location'
            ..type = 'Player'
            ..isFinal = true
            ..ctors = [''],
            member('location')
            ..doc = 'Location of the move'
            ..type = 'BoardLocation'
            ..isFinal = true
            ..ctors = [''],
          ],
          class_('i_board')
          ..doc = 'Interface to a tic-tac-toe board'
          ..isAbstract = true,
          class_('board')
          ..defaultMemberAccess = IA
          ..doc = 'Implementation of tick tack toe board'
          ..ctorCustoms = ['']
          ..extend = 'IBoard'
          ..members = [
            member('game_dim')
            ..doc = 'Dimensions of the game'
            ..type = 'int'
            ..isFinal = true
            ..access = RO
            ..ctorInit = '3'
            ..ctorsOpt = [''],
            member('position_states')
            ..doc = 'Represents the state of each of the positions in the game'
            ..type = 'List<List<PositionState>>',
            member('game_state')
            ..doc = 'State of game - updated on completion of each move'
            ..access = RO
            ..type = 'GameState',
            member('empty_slots')
            ..doc = 'Number of slots that are currently empty'
            ..access = RO
            ..type = 'int'
          ]
          ,
          class_('i_game_engine')
          ..doc = 'Interface to the game play engine'
          ..isAbstract = true,
          class_('basic_game_engine')
          ..defaultMemberAccess = IA
          ..doc = 'One approach to playing the game'
          ..extend = 'IGameEngine'
          ..members = [
            member('board')
            ..doc = 'Board for a game of tic-tac-toe'
            ..type = 'Board'
            ..classInit = 'new Board()',
            member('next_player')
            ..doc = 'Next player to move - X goes first by default'
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