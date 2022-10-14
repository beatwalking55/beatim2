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
                sensingBPM = previous_sensingBPM - 10;
                previous_sensingBPM -= 10;
              });
              playlist = musicselect(artist: artist,BPM: sensingBPM);
            }, child: Text("前回より遅め(${previous_sensingBPM - 10})")
            ),
            TextButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder:(context) =>PlayPage()));
              setState(() {
                sensingBPM = previous_sensingBPM;
              });
              playlist = musicselect(artist:artist,BPM:sensingBPM);
            }, child: Text("前回(${previous_sensingBPM})")
            ),
            TextButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder:(context) =>PlayPage()));
              setState(() {
                sensingBPM = previous_sensingBPM + 10;
                previous_sensingBPM += 10;
              });
              playlist = musicselect(artist: artist, BPM: sensingBPM);
            }, child: Text("前回より早め(${previous_sensingBPM + 10})")
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
