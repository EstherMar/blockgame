import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tetris/juego/gamer.dart';
import 'package:tetris/generador/i18n.dart';
import 'package:tetris/material/audios.dart';
import 'package:tetris/panel/page_portrait.dart';
import 'juego/keyboard.dart';

void tetris() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  _disableDebugPrint();
  runApp(Start());
}

void _disableDebugPrint() {
  bool debug = false;
  assert(() {
    debug = true;
    return true;
  }());
  if (!debug) {
    debugPrint = (String message, {int wrapWidth}) {
    };
  }
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();


class Start extends StatefulWidget {

  _StartState createState() => _StartState();
}

class _StartState extends State <Start>{

  void initState() {

    super.initState();
  }

  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: Sound(child: Game(child: KeyboardController(child: _Tetris()))),
      ),
    );
  }
}

class _Tetris extends StatelessWidget {
  Widget build(BuildContext context) {

    bool land = MediaQuery.of(context).orientation == Orientation.landscape;
    return land ? new PageLand() : new PagePortrait();
  }
}
