import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tetris/juego/block.dart';
import 'package:tetris/juego/gamer.dart';
import 'package:tetris/material/briks.dart';
import 'package:tetris/material/images.dart';

class StatusPanel extends StatelessWidget {

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(height: 10),
          Text("Puntuacion",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Number(number: GameState.of(context).points),
          SizedBox(height: 10),
          Text("Líneas",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Number(number: GameState.of(context).cleared),
          SizedBox(height: 10),
          Text("Nivel",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Number(number: GameState.of(context).level),
          SizedBox(height: 10),
          Text("Próximo",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          _NextBlock(),
          Spacer(),
          _GameStatus(),
        ],
      ),
    );
  }
}

class _NextBlock extends StatelessWidget {

  Widget build(BuildContext context) {
    List<List<int>> data = [List.filled(4, 0), List.filled(4, 0)];
    final next = BLOCK_SHAPES[GameState.of(context).next.type];
    for (int i = 0; i < next.length; i++) {
      for (int j = 0; j < next[i].length; j++) {
        data[i][j] = next[i][j];
      }
    }
    return Column(
      children: data.map((list) {
        return Row(
          children: list.map((b) {
            return b == 1 ? Brik.normal() : Brik.empty();
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _GameStatus extends StatefulWidget {

  _GameStatusState createState() {
    return new _GameStatusState();
  }
}

class _GameStatusState extends State<_GameStatus> {
  Timer _timer;

  void initState() {
    super.initState();
  }

  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconSound(enable: GameState.of(context).muted),
        IconPause(enable: GameState.of(context).states == GameStates.paused),
      ],
    );
  }
}
