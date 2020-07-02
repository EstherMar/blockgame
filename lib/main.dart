import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tetris/tetris.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:tetris/records.dart';

void main() {
  Admob.initialize(getAppId());
  runApp(MaterialApp(
      initialRoute: "/",
      routes: {
          "/" : (context) => MyApp(),
          "/tetris" : (context) => Start(),
          "/records" : (context) => record(),
        }
    )
  );
}

String getAppId() {
  if (Platform.isIOS) {
    return null;
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-8368920540183259~8685775935';
  }
  return null;
}

class MyApp extends StatefulWidget {
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey( );
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;

  void initState() {
    super.initState( );
    bannerSize = AdmobBannerSize.FULL_BANNER;

    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId( ),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
    );
    interstitialAd.load( );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage( "assets/background.jpg" ),
                        fit: BoxFit.cover
                    )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset( "assets/iconosinfondo.png",
                      fit: BoxFit.fill,
                      width: 300,
                      height: 350, ),
                    RaisedButton(
                      child: Text( "Comenzar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      textColor: Colors.white,
                      elevation: 15,
                      splashColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular( 40 ),
                          side: BorderSide(
                              color: Colors.black
                          )
                      ),
                      color: Colors.blue,
                      onPressed: () async {
                        if (await interstitialAd.isLoaded) {
                          interstitialAd.show();
                        }
                        Navigator.pushNamed(context, '/tetris');
                      }
                    ),
                    SizedBox( height: 15, ),
                    RaisedButton(
                      child: Text( "  Records  ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      textColor: Colors.white,
                      elevation: 15,
                      splashColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular( 40 ),
                        side: BorderSide(
                            color: Colors.black
                        ),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.pushNamed(context, '/records');
                      },
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only( top: 40.0 ),
                        child: AdmobBanner(
                          adUnitId: getBannerAdUnitId( ),
                          adSize: bannerSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        );
  }

  void dispose() {
    interstitialAd.dispose( );
    super.dispose( );
  }

  getBannerAdUnitId() {
    if (Platform.isIOS) {
      return null;
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-8368920540183259/7528946246';
    }
    return null;
  }

  String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return null;
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-8368920540183259/7744568668';
    }
    return null;
  }
}



