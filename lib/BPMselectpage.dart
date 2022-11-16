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

  // //ペース調整バーに使う変数。それぞれ　バーの初期値、バーの最小値、バーの最大値
  // double _runningpase = 333;
  // double _min_runningpase = 240;
  // double _max_runningpase = 420;
  //
  // //BPM算出に使う。BPM＝(この値)/走るペース
  // double _pase = 333*176;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BPMを選んでね 新規計測もできるよ"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // //ペースから計算する部分
            // Container(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text("ペースから自動で計算", style: TextStyle(fontSize: 20),),
            //       SizedBox(height: 10,),
            //       Text("${_runningpase~/60}min${(_runningpase%60).toInt()}s/km", style: TextStyle(fontSize: 30),), //ランニングペース(kmあたり）を表示
            //       Text("BPM:${(176*333/_runningpase).toStringAsFixed(1)}",style: TextStyle(fontSize: 30),), //ランニングペースからBPMを計算して表示
            //       Text("ペースを設定",style: TextStyle(fontSize: 20),),
            //       Transform.rotate(
            //         angle: pi,//逆向きにする
            //         child: Slider(
            //             inactiveColor: Colors.blue,//左側の色
            //             activeColor: Colors.blue.shade50,//右側の色
            //             thumbColor: Colors.blue,//バーの丸いやつの色
            //             value: _runningpase,//バーの初期値を設定
            //             min: _min_runningpase,
            //             max: _max_runningpase,
            //             onChanged:(value){
            //               setState(() {
            //                 _runningpase = value;
            //               });
            //             }
            //         ),
            //       ),
            //       //計算したBPMを設定してplaypageに行くボタン。
            //       ElevatedButton(onPressed: (){
            //         Navigator.push(context,MaterialPageRoute(builder:(context) =>PlayPage()));
            //         setState(() {
            //           sensingBPM = 176*333/_runningpase;
            //           previous_sensingBPM = 176*333/_runningpase;
            //         });
            //         playlist = musicselect(genre:genre, artist: artist, BPM: sensingBPM);
            //       }, child: Text("このペースで走る",style: TextStyle(fontSize: 30),)
            //       ),
            //     ],
            //   ),
            // ),
            // //中間にある隙間。
            // SizedBox(height: 50,),
            //過去のBPMから選ぶ部分。
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("前回のBPMで再開", style: TextStyle(fontSize: 20),),
                  SizedBox(height: 10,),
                  //前回のBPM-10を選ぶボタン
                  TextButton(onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder:(context) =>(PlayPage())));
                    setState(() {
                      sensingBPM = previous_sensingBPM - 10;
                      previous_sensingBPM -= 10;
                    });
                    playlist = musicselect(genre:genre, artist:artist, BPM:sensingBPM);
                  }, child: Text("前回より遅め(${previous_sensingBPM - 10})")
                  ),
                  //前回のBPMを選ぶボタン
                  TextButton(onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder:(context) =>PlayPage()));
                    setState(() {
                      sensingBPM = previous_sensingBPM;
                    });
                    playlist = musicselect(genre:genre, artist:artist, BPM:sensingBPM);
                  }, child: Text("前回(${previous_sensingBPM})")
                  ),
                  //前回のBPM+10を選ぶボタン
                  TextButton(onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder:(context) =>PlayPage()));
                    setState(() {
                      sensingBPM = previous_sensingBPM + 10;
                      previous_sensingBPM += 10;
                    });
                    playlist = musicselect(genre:genre, artist: artist, BPM: sensingBPM);
                  }, child: Text("前回より早め(${previous_sensingBPM + 10})")
                  ),
                ],
              ),
            ),
            //BPMを新規計測する部分。
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
            //前のページにもどるボタン。画面上に出てくる左矢印と同じ機能。
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
