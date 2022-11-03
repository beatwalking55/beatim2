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
  double _ratio = 1;
  double _min_ratio = 0.7;
  double _max_ratio = 1.5;
  double _pase = 333*176;
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
              playlist = musicselect(genre:genre, artist:artist, BPM:sensingBPM);
            }, child: Text("前回より遅め(${previous_sensingBPM - 10})(${((_pase/_ratio)/(previous_sensingBPM-10))~/60}min${(((_pase/_ratio)/(previous_sensingBPM-10))%60).toInt()}s/km)")
            ),
            TextButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder:(context) =>PlayPage()));
              setState(() {
                sensingBPM = previous_sensingBPM;
              });
              playlist = musicselect(genre:genre, artist:artist, BPM:sensingBPM);
            }, child: Text("前回(${previous_sensingBPM})(${((_pase/_ratio)/previous_sensingBPM)~/60}min${(((_pase/_ratio)/previous_sensingBPM)%60).toInt()}s/km)")
            ),
            TextButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder:(context) =>PlayPage()));
              setState(() {
                sensingBPM = previous_sensingBPM + 10;
                previous_sensingBPM += 10;
              });
              playlist = musicselect(genre:genre, artist: artist, BPM: sensingBPM);
            }, child: Text("前回より早め(${previous_sensingBPM + 10})(${((_pase/_ratio)/(previous_sensingBPM+10))~/60}min${(((_pase/_ratio)/(previous_sensingBPM+10))%60).toInt()}s/km)")
            ),
            TextButton(onPressed: () async {
              setState(() {
                comefrom = "bpmselectpage";
              });
              // player.pause();
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder:(context) => BPMSensingPage()
                  )
              );
              setState(() {});
            }, child: Text("新しく登録（計測ページへ）")),
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("アーティスト選択にもどる")
            ),
            SizedBox(width: 0,height: 20,),
            Text("走るペース"),
            Slider(
                value: _ratio,
                min: _min_ratio,
                max: _max_ratio,
                onChanged:(value){
                  setState(() {
                    _ratio = value;
                  });
                }
                )
          ],
        ),
      ),
    );
  }
}
