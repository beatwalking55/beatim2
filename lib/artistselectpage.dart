import 'package:beatim/BPMselectpage.dart';
import 'package:flutter/material.dart';
import 'variables.dart';
import 'musicdata.dart';

class ArtistSelectPage extends StatefulWidget {
  const ArtistSelectPage({Key? key}) : super(key: key);

  @override
  State<ArtistSelectPage> createState() => _artistselectState();
}

class _artistselectState extends State<ArtistSelectPage> {
  final List artistList = List.generate(musics.length, (index) => musics[index]['artist']).toSet().toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("好きなアーティストを選んでね"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
           Flexible(
               child: ListView.builder(
                 itemCount: artistList.length,
                 itemBuilder: (BuildContext context,int index){
                   return Container(
                     child: TextButton(onPressed: (){
                       Navigator.push(context,MaterialPageRoute(builder:(context) =>BPMSelectPage()));
                       setState(() {
                         artist = artistList[index];
                       });
                     }, child: Text(artistList[index]),
                     ),
                   );
                 },
               ),
           ),
           TextButton(onPressed: (){
             Navigator.pop(context);
           }, child: Text("ジャンル選択画面にもどる")
           ),
          ],
        ),
      ),
    );
  }
}
