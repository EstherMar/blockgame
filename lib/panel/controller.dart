import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tetris/juego/gamer.dart';
import 'package:imagebutton/imagebutton.dart';

class GameController extends StatelessWidget {
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          LeftController(),
          DirectionController(),
        ],
      ),
    );
  }
}

class DirectionController extends StatelessWidget {

  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Transform.rotate(
          angle: math.pi / 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ImageButton(
                    children: <Widget>[],
                      width: 60,
                      height: 60,
                      pressedImage: Image.asset(
                        "assets/buttonDirection.png",
                      ),
                      unpressedImage: Image.asset("assets/buttonDirection.png"),
                      onTap: () {
                        Game.of(context).rotate();
                      }),
                  SizedBox(width: 16),
                  ImageButton(
                      children: <Widget>[],
                      width: 60,
                      height: 60,
                      pressedImage: Image.asset(
                        "assets/buttonDirection4.png",
                      ),
                      unpressedImage: Image.asset("assets/buttonDirection4.png"),
                      onTap: () {
                        Game.of(context).right();
                      }),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ImageButton(
                      children: <Widget>[],
                      width: 60,
                      height: 60,
                      pressedImage: Image.asset(
                        "assets/buttonDirection2.png",
                      ),
                      unpressedImage: Image.asset("assets/buttonDirection2.png"),
                      onTap: () {
                        Game.of(context).left();
                      }),
                  SizedBox(width: 16),
                  ImageButton(
                    children: <Widget>[],
                    width: 60,
                    height: 60,
                    pressedImage: Image.asset(
                      "assets/buttonDirection3.png",
                    ),
                    unpressedImage: Image.asset("assets/buttonDirection3.png"),
                    onTap: () {
                      Game.of(context).down();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SystemButtonGroup extends StatelessWidget {

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
         ImageButton(
            children: <Widget>[],
              width: 20,
              height: 20,
              pressedImage: Image.asset(
                "assets/soundicon.png",
              ),
              unpressedImage: Image.asset("assets/soundicon.png"),
              onTap: () {
                Game.of(context).soundSwitch();
              }),
        SizedBox (height: 20,),
          ImageButton(
            children: <Widget>[],
              width: 20,
              height: 20,
              pressedImage: Image.asset(
                "assets/pausaicon.png",
              ),
              unpressedImage: Image.asset("assets/starticon.png"),
              onTap: () {
                Game.of(context).pauseOrResume();
              }),
        SizedBox (height: 20,),
          ImageButton(
              children: <Widget>[],
              width: 20,
              height: 20,
              pressedImage: Image.asset(
                "assets/reseticon.png",
              ),
              unpressedImage: Image.asset("assets/reseticon.png"),
              onTap: () {
                Game.of(context).reset();
              }),
      ]
    );
  }
}

class LeftController extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SystemButtonGroup(),
      ],
    );
  }
}

class _Button extends StatefulWidget {
  final Size size;
  final Widget icon;

  final VoidCallback onTap;
  final Color color;
  final bool enableLongPress;

  const _Button(
      {Key key,
      this.size,
      this.onTap,
      this.icon,
      this.color = Colors.blue,
      this.enableLongPress = true})
      : super(key: key);

  _ButtonState createState() {
    return new _ButtonState();
  }
}

class _ButtonState extends State<_Button> {
  Timer _timer;
  bool _tapEnded = false;
  Color _color;

  void didUpdateWidget(_Button oldWidget) {
    super.didUpdateWidget(oldWidget);
    _color = widget.color;
  }

  void initState() {
    super.initState();
    _color = widget.color;
  }

  Widget build(BuildContext context) {
    return Material(
      color: _color,
      elevation: 2,
      shape: CircleBorder(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) async {
          setState(() {
            _color = widget.color.withOpacity(0.5);
          });
          if (_timer != null) {
            return;
          }
          _tapEnded = false;
          widget.onTap();
          if (!widget.enableLongPress) {
            return;
          }
          await Future.delayed(const Duration(milliseconds: 300));
          if (_tapEnded) {
            return;
          }
          _timer = Timer.periodic(const Duration(milliseconds: 60), (t) {
            if (!_tapEnded) {
              widget.onTap();
            } else {
              t.cancel();
              _timer = null;
            }
          });
        },
        onTapCancel: () {
          _tapEnded = true;
          _timer?.cancel();
          _timer = null;
          setState(() {
            _color = widget.color;
          });
        },
        onTapUp: (_) {
          _tapEnded = true;
          _timer?.cancel();
          _timer = null;
          setState(() {
            _color = widget.color;
          });
        },
        child: SizedBox.fromSize(
          size: widget.size,
        ),
      ),
    );
  }
}
