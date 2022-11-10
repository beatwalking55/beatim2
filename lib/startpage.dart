import 'package:beatim/artistselectpage.dart';
import 'package:beatim/genreselectpage.dart';
import 'package:beatim/musicselectfunction.dart';
import 'package:flutter/material.dart';
import 'variables.dart';
import 'musicdata.dart';
import 'playpage.dart';
import 'dart:math';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List genreList = List.generate(musics.length, (index) => musics[index]['genre1']).toSet().toList();
  var random = new Random();
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text("スタートページ"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            TextButton(onPressed: (){
              setState(() {
                genre = "free";
                artist = "free";
                playlist = musicselect(genre: genre,artist:artist,BPM: previous_sensingBPM);
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) => PlayPage()));
            }, child: Text("おまかせ")),
            TextButton(
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => genreselectpage()));
                },
                 child: Text("ジャンルから選ぶ")),
            TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ArtistSelectPage()));
                },
                child: Text("アーティストから選ぶ")),
          ],
        ),
      )
    );
  }
}