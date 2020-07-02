import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tetris/panel/controller.dart';
import 'package:tetris/panel/screen.dart';

part 'page_land.dart';

class PagePortrait extends StatefulWidget {

  PagePortraitState createState() => PagePortraitState();
  }

class PagePortraitState  extends State<PagePortrait> {

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenW = size.width * 0.8;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration( image: new DecorationImage(
            image: AssetImage("assets/background.jpg"), fit: BoxFit.cover )
        ),
        child: Padding(
          padding: MediaQuery.of(context).padding,
          child: Column(
            children: <Widget>[
              Center(
                child: _ScreenDecoration( child: Screen( width: screenW ) ), ),
              Expanded( child: GameController( ) ),
            ],
          ),
        ),
      ),
    );
  }
}