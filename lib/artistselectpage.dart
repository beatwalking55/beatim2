import 'package:beatim/playpage.dart';
import 'package:flutter/material.dart';
import 'variables.dart';
import 'musicdata.dart';

class ArtistSelectPage extends StatefulWidget {
  const ArtistSelectPage({Key? key}) : super(key: key);

  @override
  State<ArtistSelectPage> createState() => _ArtistselectState();
}

class _ArtistselectState extends State<ArtistSelectPage> {
  final List artistList = List.generate(musics.length, (index) => musics[index]['artist']).toSet().toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("アーティストを選択",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget> [
              //アーティスト一覧。
             Flexible(
                 child: ListView.builder(
                   itemCount: artistList.length,
                   itemBuilder: (BuildContext context,int index){
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
                              genre = "free";
                              artist = artistList[index];
                            });
                         }, child: Text(artistList[index],style: const TextStyle(fontSize: 30,color: Colors.white),),
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
    );
  }
}
