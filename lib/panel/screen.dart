import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tetris/juego/gamer.dart';
import 'package:tetris/material/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;
import '../juego/block.dart';
import '../material/briks.dart';
import 'player_panel.dart';
import 'status_panel.dart';

const Color SCREEN_BACKGROUND = Colors.white;
class Screen extends StatelessWidget {
  final double width;

  const Screen({Key key, @required this.width}) : super(key: key);

  Screen.fromHeight(double height) : this(width: ((height - 6) / 2 + 6) / 0.6);

  Widget build(BuildContext context) {

    final playerPanelWidth = width * 0.6;
    return Shake(
      shake: GameState.of(context).states == GameStates.drop,
      child: SizedBox(
        height: (playerPanelWidth - 6) * 2 + 6,
        width: width,
        child: Container(
          color: SCREEN_BACKGROUND,
          child: GameMaterial(
            child: BrikSize(
              size: getBrikSizeForScreenWidth(playerPanelWidth),
              child: Row(
                children: <Widget>[
                  PlayerPanel(width: playerPanelWidth),
                  SizedBox(
                    width: width - playerPanelWidth,
                    child: StatusPanel(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class Shake extends StatefulWidget {
  final Widget child;

  final bool shake;

  const Shake({Key key, @required this.child, @required this.shake})
      : super(key: key);

  _ShakeState createState() => _ShakeState();
}

class _ShakeState extends State<Shake> with TickerProviderStateMixin {
  AnimationController _controller;

  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150))
          ..addListener(() {
            setState(() {});
          });
    super.initState();
  }

  void didUpdateWidget(Shake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake) {
      _controller.forward(from: 0);
    }
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  v.Vector3 _getTranslation() {
    double progress = _controller.value;
    double offset = sin(progress * pi) * 1.5;
    return v.Vector3(0, offset, 0.0);
  }

  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translation(_getTranslation()),
      child: widget.child,
    );
  }
}
