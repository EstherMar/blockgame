import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tetris/bd/classrecord.dart';
import 'package:tetris/bd/databaserecord.dart';
import 'package:tetris/material/audios.dart';
import 'block.dart';

const GAME_PAD_MATRIX_H = 20;
const GAME_PAD_MATRIX_W = 10;

Color colorbloque;

enum GameStates {
  none,
  paused,
  running,
  reset,
  mixing,
  clear,
  drop,
}

TextEditingController NombreTEC = TextEditingController();
TextEditingController PuntuacionTEC = TextEditingController();
TextEditingController NivelTEC = TextEditingController();

class Game extends StatefulWidget {
  final Widget child;

  const Game({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  State<StatefulWidget> createState() {
    return GameControl();
  }

  static GameControl of(BuildContext context) {
    final state = context.ancestorStateOfType(TypeMatcher<GameControl>());
    assert(state != null, "must wrap this context with [Game]");
    return state;
  }
}

const _REST_LINE_DURATION = const Duration(milliseconds: 50);
const _LEVEL_MAX = 20;
const _LEVEL_MIN = 1;
const _SPEED = [
  const Duration(milliseconds: 800),
  const Duration(milliseconds: 760),
  const Duration(milliseconds: 720),
  const Duration(milliseconds: 680),
  const Duration(milliseconds: 640),
  const Duration(milliseconds: 600),
  const Duration(milliseconds: 560),
  const Duration(milliseconds: 520),
  const Duration(milliseconds: 400),
  const Duration(milliseconds: 480),
  const Duration(milliseconds: 440),
  const Duration(milliseconds: 400),
  const Duration(milliseconds: 360),
  const Duration(milliseconds: 320),
  const Duration(milliseconds: 280),
  const Duration(milliseconds: 240),
  const Duration(milliseconds: 200),
  const Duration(milliseconds: 160),
  const Duration(milliseconds: 120),
  const Duration(milliseconds: 80),
];

class GameControl extends State<Game> with RouteAware {

  GameControl() {
    for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
      _data.add( List.filled( GAME_PAD_MATRIX_W, 0 ) );
      _mask.add( List.filled( GAME_PAD_MATRIX_W, 0 ) );
    }
  }

  final List<List<int>> _data = [];
  final List<List<int>> _mask = [];

  int _level = 1;
  int _points = 0;
  int _cleared = 0;
  Block _current;
  Block _next = Block.getRandom();

  GameStates _states = GameStates.none;


  Block _getNext() {
    final next = _next;
    _next = Block.getRandom();
    return next;
  }


  SoundState get _sound => Sound.of( context );

  void rotate() {
    if (_states == GameStates.running && _current != null) {
      final next = _current.rotate( );
      if (next.isValidInMatrix( _data )) {
        _current = next;
        _sound.rotate( );
      }
    }
    setState( () {} );
  }

  void right() {
    if (_states == GameStates.none && _level < _LEVEL_MAX) {
      _level++;
    } else if (_states == GameStates.running && _current != null) {
      final next = _current.right( );
      if (next.isValidInMatrix( _data )) {
        _current = next;
        _sound.move( );
      }
    }
    setState( () {} );
  }

  void left() {
    if (_states == GameStates.none && _level > _LEVEL_MIN) {
      _level--;
    } else if (_states == GameStates.running && _current != null) {
      final next = _current.left( );
      if (next.isValidInMatrix( _data )) {
        _current = next;
        _sound.move( );
      }
    }
    setState( () {} );
  }

  void drop() async {
    if (_states == GameStates.running && _current != null) {
      for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
        final fall = _current.fall( step: i + 1 );
        if (!fall.isValidInMatrix( _data )) {
          _current = _current.fall( step: i );
          _states = GameStates.drop;
          setState( () {} );
          await Future.delayed( const Duration( milliseconds: 100 ) );
          _mixCurrentIntoData( mixSound: _sound.fall );
          break;
        }
      }
      setState( () {} );
    } else if (_states == GameStates.paused || _states == GameStates.none) {
      _startGame( );
    }
  }

  void down({bool enableSounds = true}) {
    if (_states == GameStates.running && _current != null) {
      final next = _current.fall( );
      if (next.isValidInMatrix( _data )) {
        _current = next;
        if (enableSounds) {
          _sound.move( );
        }
      } else {
        _mixCurrentIntoData( );
      }
    }
    setState( () {} );
  }

  Timer _autoFallTimer;

  Future<void> _mixCurrentIntoData({void mixSound()}) async {
    if (_current == null) {
      return;
    }
    _autoFall( false );

    _forTable( (i, j) => _data[i][j] = _current.get( j, i ) ?? _data[i][j] );

    final clearLines = [];
    for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
      if (_data[i].every( (d) => d == 1 )) {
        clearLines.add( i );
      }
    }

    if (clearLines.isNotEmpty) {
      setState( () => _states = GameStates.clear );

      _sound.clear( );

      for (int count = 0; count < 5; count++) {
        clearLines.forEach( (line) {
          _mask[line].fillRange(
              0, GAME_PAD_MATRIX_W, count % 2 == 0 ? -1 : 1 );
        } );
        setState( () {} );
        await Future.delayed( Duration( milliseconds: 100 ) );
      }
      clearLines
          .forEach( (line) =>
          _mask[line].fillRange( 0, GAME_PAD_MATRIX_W, 0 ) );

      clearLines.forEach( (line) {
        _data.setRange( 1, line + 1, _data );
        _data[0] = List.filled( GAME_PAD_MATRIX_W, 0 );
      } );
      debugPrint( "Clear lines : $clearLines" );

      _cleared += clearLines.length;
      _points += clearLines.length * _level * 5;

      int level = (_cleared ~/ 50) + _LEVEL_MIN;
      _level = level <= _LEVEL_MAX && level > _level ? level : _level;
    } else {
      _states = GameStates.mixing;
      if (mixSound != null) mixSound();
      _forTable( (i, j) => _mask[i][j] = _current.get( j, i ) ?? _mask[i][j] );
      setState( () {} );
      await Future.delayed( const Duration( milliseconds: 200 ) );
      _forTable( (i, j) => _mask[i][j] = 0 );
      setState( () {} );
    }
    _current = null;
    if (_data[0].contains( 1 )) {
      puntuaciones();
      return;
    } else {
      _startGame( );
    }
  }

  static void _forTable(dynamic function(int row, int column)) {
    for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
      for (int j = 0; j < GAME_PAD_MATRIX_W; j++) {
        final b = function( i, j );
        if (b is bool && b) {
          break;
        }
      }
    }
  }

  void _autoFall(bool enable) {
    if (!enable && _autoFallTimer != null) {
      _autoFallTimer.cancel( );
      _autoFallTimer = null;
    } else if (enable) {
      _autoFallTimer?.cancel( );
      _current = _current ?? _getNext();
      _autoFallTimer = Timer.periodic( _SPEED[_level - 1], (t) {
        down( enableSounds: false );
      } );
    }
  }

  void pause() {
    if (_states == GameStates.running) {
      _states = GameStates.paused;
    }
    setState( () {} );
  }

  void pauseOrResume() {
    if (_states == GameStates.running) {
      pause( );
    } else if (_states == GameStates.paused || _states == GameStates.none) {
      _startGame( );
    }
  }

  void reset() async {
    if (_states == GameStates.none) {
      _startGame();
      return;
    }
    if (_states == GameStates.reset) {
      return;
    }
    _sound.start( );
    _states = GameStates.reset;
        () async {
      int line = GAME_PAD_MATRIX_H;
      await Future.doWhile( () async {
        line--;
        for (int i = 0; i < GAME_PAD_MATRIX_W; i++) {
          _data[line][i] = 1;
        }
        setState( () {} );
        await Future.delayed( _REST_LINE_DURATION );
        return line != 0;
      } );
      _current = null;
      _getNext();
      _points = 0;
      _cleared = 0;
      await Future.doWhile( () async {
        for (int i = 0; i < GAME_PAD_MATRIX_W; i++) {
          _data[line][i] = 0;
        }
        setState( () {} );
        line++;
        await Future.delayed( _REST_LINE_DURATION );
        return line != GAME_PAD_MATRIX_H;
      } );
      setState( () {
        _states = GameStates.none;
      } );
    }();
  }

  void _startGame() async {
    if (_states == GameStates.running && _autoFallTimer?.isActive == false) {
      return;
    }

    _states = GameStates.running;
    _autoFall( true );
    setState( () {} );
  }

  Widget build(BuildContext context) {
    List<List<int>> mixed = [];
    for (var i = 0; i < GAME_PAD_MATRIX_H; i++) {
      mixed.add( List.filled( GAME_PAD_MATRIX_W, 0 ) );
      for (var j = 0; j < GAME_PAD_MATRIX_W; j++) {
        int value = _current?.get( j, i ) ?? _data[i][j];
        if (_mask[i][j] == -1) {
          value = 0;
        } else if (_mask[i][j] == 1) {
          value = 2;
        }
        mixed[i][j] = value;
      }
    }
    debugPrint( "game states : $_states" );
    return GameState(
        mixed,
        _states,
        _level,
        _sound.mute,
        _points,
        _cleared,
        _next,
        child: widget.child );
  }

  void soundSwitch() {
    setState( () {
      _sound.mute = !_sound.mute;
    } );
  }

  void puntuaciones() {
   showDialog(context: context,
   builder: (BuildContext context) {
      return AlertDialog (
        title: new Text ("Game Over!",
        style: TextStyle (
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Colors.red),
        textAlign: TextAlign.center,),
        content: new Text ("Puntuación alcanzada: $_points"),
        actions: <Widget>[
          new FlatButton(
              onPressed: () {
                guardarpuntuacion();
              },
              child: new Text ( "Guardar Puntuación" ),),
           new FlatButton (
              onPressed: () {
              Navigator.pop( context );
                reset();
              },
              child: new Text ( "Cancelar y Jugar" ),),
            ],
          );
        }
      );
    }

  void guardarpuntuacion() {
    showDialog(context: context,
        builder: (BuildContext context) {
      return AlertDialog (
        content: TextFormField(
          // ignore: missing_return
          validator: (value){
            if (value.isEmpty) {
              return 'No dejes este campo vacío';
            }
          },
          controller: NombreTEC,
          maxLength: 3,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            labelText: 'Ingresa un nombre',),
          ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () async {
              print (NombreTEC.text);
              print (_points.toInt());
              print (_level.toInt());

              await RecordDatabaseProvider.db.addRecordsToDatabase( new classrecord (
                nombre: NombreTEC.text,
                puntos: _points.toInt(),
                nivel: _level.toInt(),
              ));
              Navigator.pop(context);
              Navigator.pop(context);
              reset();
            },
            child: new Text ( "Guardar" ),),
          new FlatButton (
            onPressed: () {
              Navigator.pop(context);
              reset();
              },
            child: new Text ( "Cancelar" ),),
          ],
        );
      }
    );
  }
}


class GameState extends InheritedWidget {
  GameState(this.data, this.states, this.level, this.muted, this.points,
      this.cleared, this.next,
      {Key key, this.child})
      : super( key: key, child: child );

  final Widget child;

  final List<List<int>> data;
  final GameStates states;
  final int level;
  final bool muted;
  final int points;
  final int cleared;
  final Block next;

  static GameState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType( GameState ) as GameState);
  }

  bool updateShouldNotify(GameState oldWidget) {
    return true;
  }
}
