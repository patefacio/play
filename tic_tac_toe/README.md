# Console Tic Tac Toe Game

This is a basic implementation of the game _tic tac toe_. Only the
game engine and a simple console application for game play are
currently available. The dependencies and stubbed out components are
set up to make this into a GUI component - but that is incomplete -
(so stay clear of _lib/components_).

# Running Tests
  To run the tests first install the [Dart
  Language](http://www.dartlang.org/#get-started).

## Running From Dart Editor  
  * Download the project in some preferred area

        cd ~/tmp
        git clone https://github.com/patefacio/play

  * Load the project in the Dart Editor
  * Right click on the _pubspec.yaml_ file and do a _pub install_
  * Right click on the desired test in the test folder and click
    run. *NOTE*: there is a wrapper for all_tests.dart which only
    runs from the console (_see below_).

## Downloading and Running From Command Line

   * Dowdload the project in some preferred area

        bash-3.2$ git clone https://github.com/patefacio/play
        Cloning into 'play'...
        remote: Counting objects: 161, done.        
        remote: Compressing objects: 100% (83/83), done.        
        remote: Total 161 (delta 60), reused 144 (delta 43)        
        Receiving objects: 100% (161/161), 31.75 KiB, done.
        Resolving deltas: 100% (60/60), done.

   * Do a _pub install_
  
        bash-3.2$ cd play/tic_tac_toe/
        bash-3.2$ pub install
        Resolving dependencies..................
        Dependencies installed!

   * Run the desired tests

        bash-3.2$ dart test/all_tests.dart 
        unittest-suite-wait-for-done
        2013-08-01 07:07:40.788	basic_game_engine_test	[INFO]:	Got expected: Instance of 'InvalidBoard'
        2013-08-01 07:07:40.842	Unbeatable	[FINE]:	Completed with 185 human moves
        2013-08-01 07:07:40.860	Unbeatable	[FINE]:	Completed with 361 human moves
        2013-08-01 07:07:40.870	Unbeatable	[FINE]:	Completed with 537 human moves
        2013-08-01 07:07:40.881	Unbeatable	[FINE]:	Completed with 713 human moves
        2013-08-01 07:07:40.889	Unbeatable	[FINE]:	Completed with 889 human moves
        2013-08-01 07:07:40.896	Unbeatable	[FINE]:	Completed with 1065 human moves
        2013-08-01 07:07:40.904	Unbeatable	[FINE]:	Completed with 1241 human moves
        2013-08-01 07:07:40.911	Unbeatable	[FINE]:	Completed with 1417 human moves
        2013-08-01 07:07:40.918	Unbeatable	[FINE]:	Completed with 1593 human moves
        PASS: Whos Turn Is It?: X is next
    
        PASS: Basic Engine Move Correctness: X Goes First
    
        PASS: Basic Engine Move Correctness: X Goes First Exception
    
        PASS: Basic Engine Move Correctness: X Moves To Filled Position Exception
    
        PASS: Basic Engine Move Correctness: X Moves On Game Over Exception
    
        PASS: Basic Engine Move Correctness: Invalid Board - Who Moves Next
        ...
        
        All 66 tests passed.
        unittest-suite-success
    
    
## To play the computer
   
   At a command line run the _play_computer.dart_ file.
    
        bash-3.2$ dart bin/play_computer.dart 
        You are player X - let's begin
    
        The board is: board: 
        [EMPTY, EMPTY, EMPTY]
        [EMPTY, EMPTY, EMPTY]
        [EMPTY, EMPTY, EMPTY]
        state: INCOMPLETE
    
        next: PLAYER_X
    
        Enter move as number 1 through 9
        ...
