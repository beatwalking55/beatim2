import 'package:beatim/artistselectpage.dart';
import 'package:beatim/genreselectpage.dart';
import 'package:beatim/musicselectfunction.dart';
import 'package:flutter/material.dart';
import 'variables.dart';
import 'musicdata.dart';
import 'playpage.dart';
import 'dart:math';

class startpage extends StatefulWidget {
  const startpage({Key? key}) : super(key: key);

  @override
  State<startpage> createState() => _startpageState();
}

class _startpageState extends State<startpage> {
  final List genreList = List.generate(musics.length, (index) => musics[index]['genre1']).toSet().toList();
  var random = new Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("スタートページ",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget> [
              Container(
                color: Colors.black,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),//ボタンの角をつける
                    backgroundColor: Colors.black,//ボタンの背景色
                  ),
                  onPressed: (){
                    setState(() {
                      genre = "free";
                      artist = "free";
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PlayPage()));
                  },
                  child: Text("おまかせ",style: TextStyle(fontSize: 30),)
                  ),
              ),

              //中間にある隙間。
              SizedBox(
                height: 50,
              ),

              Container(
                color: Colors.black,
                width:double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),//ボタンの角をつける
                    backgroundColor: Colors.black,//ボタンの背景色
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => genreselectpage()));
                  },
                  child: Text("ジャンルから選ぶ",style: TextStyle(fontSize: 30),)
                  ),
              ),

              //中間にある隙間。
              SizedBox(
                height: 50,
              ),

              Container(
                color: Colors.black,
                width:double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),//ボタンの角をつける
                    backgroundColor: Colors.black,//ボタンの背景色
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ArtistSelectPage()));
                  },
                  child: Text("アーティストから選ぶ",style: TextStyle(fontSize: 30),)
                  ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
