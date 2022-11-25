import 'package:beatim/BPMselectpage.dart';
import 'package:beatim/musicselectfunction.dart';
import 'package:beatim/playpage.dart';
import 'package:flutter/material.dart';
import 'variables.dart';
import 'musicdata.dart';

class ArtistSelectPage extends StatefulWidget {
  const ArtistSelectPage({Key? key}) : super(key: key);

  @override
  State<ArtistSelectPage> createState() => _artistselectState();
}

//選択されたgenreをもつartistを全て上げる。この時、返されるartistListには重複がある
// genreatristsearch(genre){
//   int i = 0;
//   List<String> artistList = [];
//   for (i = 0; i < musics.length; i++){    //musicsの長さだけiを走らせる
//     if (musics[i]['genre1'] == genre || musics[i]['genre2'] == genre){
//       artistList.add(musics[i]['artist']);  //もしgenre1かgenre2がgenreと一致すれば追加する。
//     }
//   }
//   return artistList;
// }


class _artistselectState extends State<ArtistSelectPage> {
  final List artistList = List.generate(musics.length, (index) => musics[index]['artist']).toSet().toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("好きなアーティストを選択",style: TextStyle(fontWeight: FontWeight.bold),),
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
                       decoration: BoxDecoration(
                         color: Colors.black,
                         border:Border(
                           bottom: const BorderSide(color: Colors.white30),//ボタンの下のみにボーダーラインを設定
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
                            Navigator.push(context,MaterialPageRoute(builder:(context) =>BPMSelectPage()));
                            setState(() {
                              genre = "free";
                              artist = artistList[index];
                            });
                         }, child: Text(artistList[index],style: TextStyle(fontSize: 30,color: Colors.white),),
                         ),
                       ),
                     );
                   },
                 ),
             ),
            //  TextButton(onPressed: (){
            //    Navigator.pop(context);
            //  }, child: Text("ジャンル選択画面にもどる")
            //  ),
            ],
          ),
        ),
      ),
    );
  }
}
