part of 'page_portrait.dart';

class PageLand extends StatelessWidget {

  Widget build(BuildContext context) {
    var height = MediaQuery.of( context ).size.height;
    height -= MediaQuery.of( context ).viewInsets.vertical;
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
            image: new DecorationImage(
                image: AssetImage("assets/background.jpg"), fit: BoxFit.cover )
        ),
        child: Padding(
          padding: MediaQuery
              .of( context )
              .padding,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SystemButtonGroup(),
                  ],
                ),
              ),
              _ScreenDecoration( child: Screen.fromHeight( height * 0.8 ) ),
              SizedBox( width: 20, ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DirectionController( ),
                  ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScreenDecoration extends StatelessWidget {
  final Widget child;

  const _ScreenDecoration({Key key, @required this.child}) : super( key: key );

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: const Color( 0xFF987f0f ), width: 3.0 ),
          left: BorderSide(
              color: const Color( 0xFF987f0f ), width: 3.0 ),
          right: BorderSide(
              color: const Color( 0xFFfae36c ), width: 3.0 ),
          bottom: BorderSide(
              color: const Color( 0xFFfae36c ), width: 3.0 ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all( color: Colors.black54 ) ),
        child: Container(
          padding: const EdgeInsets.all( 3 ),
          color: SCREEN_BACKGROUND,
          child: child,
        ),
      ),
    );
  }
}

