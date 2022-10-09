import 'package:beatim/BPMselectpage.dart';
import 'package:flutter/material.dart';
import 'variables.dart';

class ArtistSelectPage extends StatefulWidget {
  const ArtistSelectPage({Key? key}) : super(key: key);

  @override
  State<ArtistSelectPage> createState() => _artistselectState();
}

class _artistselectState extends State<ArtistSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("好きなアーティストを選んでね"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           TextButton(onPressed: (){
             Navigator.push(context,MaterialPageRoute(builder:(context) =>BPMSelectPage()));
             setState(() {
               artist = "ミセス";
             });
           }, child: Text("ミセス")
           ),
           TextButton(onPressed: (){
             Navigator.push(context,MaterialPageRoute(builder:(context) =>BPMSelectPage()));
             setState(() {
               artist = "爆風スランプ";
             });
           }, child: Text("爆風スランプ")
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
