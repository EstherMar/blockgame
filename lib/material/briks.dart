import 'dart:ui';
import 'package:flutter/material.dart';

const _COLOR_NORMAL = Colors.black;
const _COLOR_NULL = Colors.blueGrey;
const _COLOR_HIGHLIGHT = Colors.black;

const _IMG_NULL = Colors.blueGrey;
const _IMG_HIGHLIGHT = Colors.red;

class BrikSize extends InheritedWidget {
  const BrikSize({
    Key key,
    this.size,
    Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  final Size size;

  static BrikSize of(BuildContext context) {
    final brikSize = context.inheritFromWidgetOfExactType(BrikSize) as BrikSize;
    assert(brikSize != null, "....");
    return brikSize;
  }

  bool updateShouldNotify(BrikSize old) {
    return old.size != size;
  }
}

class Brik extends StatelessWidget {

  final Color color;
  final Color image;

  const Brik._({Key key, this.color, this.image}) : super(key: key);
  const Brik.normal(): this._(color: _COLOR_NORMAL, image: Colors.blue);
  const Brik.empty() : this._(color: _COLOR_NULL, image: _IMG_NULL );
  const Brik.highlight() : this._(color: _COLOR_HIGHLIGHT, image: _IMG_HIGHLIGHT );

  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: BrikSize.of(context).size,
        child: Container(
          decoration: BoxDecoration (
            border: Border.all(color: color),
            color: image
            )
          ),
        );
  }
}


  