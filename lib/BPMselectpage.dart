import 'package:beatim/BPMsensingpage.dart';
import 'package:beatim/musicselectfunction.dart';
import 'package:beatim/playpage.dart';
import 'package:flutter/material.dart';
import 'variables.dart';

class BPMSelectPage extends StatefulWidget {
  const BPMSelectPage({Key? key}) : super(key: key);

  @override
  State<BPMSelectPage> createState() => _BPMSelectPageState();
}

class _BPMSelectPageState extends State<BPMSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BPMを選んでね 新規計測もできるよ"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder:(context) =>(PlayPage())));
              setState(() {
                BPM = previous_BPM - 10;
                previous_BPM -= 10;
              });
              playlist = musicselect(artist: artist,BPM: BPM);
            }, child: Text("前回より遅め(${previous_BPM - 10})")
            ),
            TextButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder:(context) =>PlayPage()));
              setState(() {
                BPM = previous_BPM;
              });
              playlist = musicselect(artist:artist,BPM:BPM);
            }, child: Text("前回(${previous_BPM})")
            ),
            TextButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder:(context) =>PlayPage()));
              setState(() {
                BPM = previous_BPM + 10;
                previous_BPM += 10;
              });
              playlist = musicselect(artist: artist, BPM: BPM);
            }, child: Text("前回より早め(${previous_BPM + 10})")
            ),
            TextButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder:(context) =>BPMSensingPage()));
            }, child: Text("新しく登録（計測ページへ）")
            ),
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("アーティスト選択にもどる")
            ),
          ],
        ),
      ),
    );
  }
}
