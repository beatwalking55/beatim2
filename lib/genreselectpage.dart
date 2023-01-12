import 'package:flutter/material.dart';
import 'package:beatim/playpage.dart';
import 'variables.dart';
import 'musicdata.dart';
import 'dart:math';

class GenreSelectPage extends StatefulWidget {
  const GenreSelectPage({Key? key}) : super(key: key);

  @override
  State<GenreSelectPage> createState() => _GenreSelectPageState();
}

class _GenreSelectPageState extends State<GenreSelectPage> {
  final List genreList = List.generate(musics.length, (index) => musics[index]['genre1']).toSet().toList();
  var random = Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("好きなジャンルを選択",style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  itemCount: genreList.length,
                  itemBuilder:(BuildContext context, int index){
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        border:Border(
                          bottom: BorderSide(color: Colors.white30),//ボタンの下のみにボーダーラインを設定
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),//ボタンの角をつける
                            backgroundColor: Colors.black,//ボタンの背景色
                          ),
                          onPressed: (){
                            Navigator.push(context,MaterialPageRoute(builder:(context) =>const PlayPage()));
                            setState(() {
                              genre = genreList[index];
                              artist = "free";
                          });
                        }, child: Text(genreList[index],style: const TextStyle(fontSize: 30, color: Colors.white),)
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
