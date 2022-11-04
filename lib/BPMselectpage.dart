import 'package:beatim/BPMsensingpage.dart';
import 'package:beatim/musicselectfunction.dart';
import 'package:beatim/playpage.dart';
import 'package:flutter/material.dart';
import 'variables.dart';
import 'dart:math';

class BPMSelectPage extends StatefulWidget {
  const BPMSelectPage({Key? key}) : super(key: key);

  @override
  State<BPMSelectPage> createState() => _BPMSelectPageState();
}

class _BPMSelectPageState extends State<BPMSelectPage> {
  @override

  //ペース調整バーに使う変数。それぞれ　バーの初期値、バーの最小値、バーの最大値
  double _runningpase = 333;
  double _min_runningpase = 240;
  double _max_runningpase = 420;

  //BPM算出に使う。BPM＝(この値)/走るペース
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

            //ペースから計算する部分
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ペースから自動で計算", style: TextStyle(fontSize: 20),),
                  SizedBox(height: 10,),
                  Text("${_runningpase~/60}min${(_runningpase%60).toInt()}s/km", style: TextStyle(fontSize: 30),),
                  Text("BPM:${(176*333/_runningpase).toStringAsFixed(1)}",style: TextStyle(fontSize: 30),),
                  Text("ペースを設定",style: TextStyle(fontSize: 20),),
                  Transform.rotate(
                    angle: pi,
                    child: Slider(
                        inactiveColor: Colors.blue,
                        activeColor: Colors.blue.shade50,
                        thumbColor: Colors.blue,
                        value: _runningpase,
                        min: _min_runningpase,
                        max: _max_runningpase,
                        onChanged:(value){
                          setState(() {
                            _runningpase = value;
                          });
                        }
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder:(context) =>PlayPage()));
                    setState(() {
                      sensingBPM = 176*333/_runningpase;
                      previous_sensingBPM = 176*333/_runningpase;
                    });
                    playlist = musicselect(genre:genre, artist: artist, BPM: sensingBPM);
                  }, child: Text("このペースで走る",style: TextStyle(fontSize: 30),)
                  ),
                ],
              ),
            ),
            //中間にある隙間。
            SizedBox(height: 50,),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("前回のBPMで再開", style: TextStyle(fontSize: 20),),
                  SizedBox(height: 10,),
                  TextButton(onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder:(context) =>(PlayPage())));
                    setState(() {
                      sensingBPM = previous_sensingBPM - 10;
                      previous_sensingBPM -= 10;
                    });
                    playlist = musicselect(genre:genre, artist:artist, BPM:sensingBPM);
                  }, child: Text("前回より遅め(${previous_sensingBPM - 10})(${((_pase)/(previous_sensingBPM-10))~/60}min${(((_pase)/(previous_sensingBPM-10))%60).toInt()}s/km)")
                  ),
                  TextButton(onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder:(context) =>PlayPage()));
                    setState(() {
                      sensingBPM = previous_sensingBPM;
                    });
                    playlist = musicselect(genre:genre, artist:artist, BPM:sensingBPM);
                  }, child: Text("前回(${previous_sensingBPM})(${((_pase)/previous_sensingBPM)~/60}min${(((_pase)/previous_sensingBPM)%60).toInt()}s/km)")
                  ),
                  TextButton(onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder:(context) =>PlayPage()));
                    setState(() {
                      sensingBPM = previous_sensingBPM + 10;
                      previous_sensingBPM += 10;
                    });
                    playlist = musicselect(genre:genre, artist: artist, BPM: sensingBPM);
                  }, child: Text("前回より早め(${previous_sensingBPM + 10})(${((_pase)/(previous_sensingBPM+10))~/60}min${(((_pase)/(previous_sensingBPM+10))%60).toInt()}s/km)")
                  ),
                ],
              ),
            ),
            // TextButton(onPressed: () async {
            //   setState(() {
            //     comefrom = "bpmselectpage";
            //   });
            //   // player.pause();
            //   await Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder:(context) => BPMSensingPage()
            //       )
            //   );
            //   setState(() {});
            // }, child: Text("新しく登録（計測ページへ）")),
            // TextButton(onPressed: (){
            //   Navigator.pop(context);
            // }, child: Text("アーティスト選択にもどる")
            // ),
          ],
        ),
      ),
    );
  }
}
