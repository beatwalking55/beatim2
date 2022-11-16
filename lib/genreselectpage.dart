import 'package:beatim/BPMselectpage.dart';
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
        title: Text("好きなジャンルを選んでね"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemCount: genreList.length,
                itemBuilder:(BuildContext context, int index){
                  return Container(
                    child: TextButton(onPressed: (){
                      Navigator.push(context,MaterialPageRoute(builder:(context) =>BPMSelectPage()));
                      setState(() {
                        genre = genreList[index];
                        artist = "free";
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
