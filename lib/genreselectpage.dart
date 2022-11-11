import 'package:flutter/material.dart';
import 'package:beatim/musicselectfunction.dart';
import 'variables.dart';
import 'musicdata.dart';
import 'playpage.dart';
import 'dart:math';

class genreselectpage extends StatefulWidget {
  const genreselectpage({Key? key}) : super(key: key);

  @override
  State<genreselectpage> createState() => _genreselectpageState();
}

class _genreselectpageState extends State<genreselectpage> {
  final List genreList = List.generate(musics.length, (index) => musics[index]['genre1']).toSet().toList();
  var random = new Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("好きなジャンルを選んでね"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemCount: genreList.length,
                itemBuilder:(BuildContext context, int index){
                  return Container(
                    child: TextButton(onPressed: (){
                      Navigator.push(context,MaterialPageRoute(builder:(context) =>PlayPage()));
                      setState(() {
                        genre = genreList[index];
                        artist = "free";
                        playlist = musicselect(genre: genreList[index], artist: artist, BPM:previous_sensingBPM );
                      });
                    }, child: Text(genreList[index])
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
