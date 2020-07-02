import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tetris/bd/classrecord.dart';
import 'package:tetris/bd/databaserecord.dart';


class record extends StatelessWidget {

  Widget build(BuildContext context) {
    return Container (
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage( "assets/background.jpg" ),
              fit: BoxFit.cover
          )
      ),
      child: FutureBuilder<List<classrecord>> (
        future: RecordDatabaseProvider.db.getAllRecords(),
        builder: (BuildContext context,
        AsyncSnapshot <List<classrecord>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder (
              physics:  BouncingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                classrecord item = snapshot.data[index];
                return Container(
                 padding: EdgeInsets.only(top: 15, bottom: 15, right: 50, left: 50),
                  child: Card(
                      color: Color (0xFFFFF9C4),
                      elevation: 20.0,
                      child: Padding (
                        padding: const EdgeInsets.only (
                            top: 30.0 , bottom: 30 , left: 50.0 , right: 50.0) ,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text ( "Jugador : ",
                                style: TextStyle (
                                  fontSize: 20
                                ),
                                textAlign: TextAlign.start,),
                                SizedBox (width: 20,),
                                Text (item.nombre,
                                  style: TextStyle (
                                      fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                textAlign: TextAlign.center,),
                              ],
                            ),
                            Row (
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text ( "Record : ",
                                  style: TextStyle (
                                      fontSize: 20
                                  ),
                                textAlign: TextAlign.start,),
                                SizedBox (width: 30,),
                                Text (item.puntos.toString(),
                                  style: TextStyle (
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                textAlign: TextAlign.center,),
                              ],
                            ),
                            Row (
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text ("Nivel : ",
                                  style: TextStyle (
                                      fontSize: 20
                                  ),
                                  textAlign: TextAlign.start,),
                                SizedBox (width: 65,),
                                Text (item.nivel.toString(),
                                  style: TextStyle (
                                      fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.center,),
                              ],
                            )
                          ],
                        ),
                      )
                  ),
                );
              },
            );
          }
          else {
            return Card(
                color: Color (0xFFFFF9C4),
                elevation: 20.0,
                child: Padding (
                  padding: const EdgeInsets.only (
                      top: 30.0 , bottom: 30 , left: 15.0 , right: 15.0) ,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text ( "Jugador :" ),
                          Text ("Nada que mostrar"),
                        ],
                      ),
                      Row (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text ( "Record: "),
                          Text ("Nada que mostrar"),
                        ],
                      ),
                      Row (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text ("Nivel:"),
                          Text (" Nada que mostrar"),
                        ],
                      )
                    ],
                  ),
                )
            );
          }
        },
      ),
    );
  }
}


