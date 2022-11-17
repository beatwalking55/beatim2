import 'package:beatim/musicselectfunction.dart';
import 'package:beatim/playpage.dart';
import 'package:beatim/BPMsensingpage.dart';
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BPMを設定してね"),
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
                  Text(
                    "バーでBPM調整",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "BPM:${sensingBPM.toStringAsFixed(1)}",
                    style: TextStyle(fontSize: 30),
                  ), //ランニングペースからBPMを計算して表示
                  Transform.rotate(
                    angle: 0, 
                    child: Slider(
                        inactiveColor: Colors.blue.shade50, //左側の色
                        activeColor: Colors.blue, //右側の色
                        thumbColor: Colors.blue, //バーの丸いやつの色
                        value: sensingBPM, //バーの初期値を設定
                        min: 80,
                        max: 200,
                        onChanged: (value) {
                          setState(() {
                            sensingBPM = value;
                          });
                        }),
                  ),
                  //計算したBPMを設定してplaypageに行くボタン。
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlayPage()));
                        setState(() {
                          sensingBPM = sensingBPM;
                          previous_sensingBPM = previous_sensingBPM;
                        });
                        playlist = musicselect(
                            genre: genre, artist: artist, BPM: sensingBPM);
                      },
                      child: Text(
                        "このBPMで走る",
                        style: TextStyle(fontSize: 30),
                      )),
                ],
              ),
            ),

            //中間にある隙間。
            SizedBox(
              height: 50,
            ),

            // 過去のBPMから選ぶ部分。
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "前回のBPMで再開",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //前回のBPMを選ぶボタン
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlayPage()));
                        setState(() {
                          sensingBPM = previous_sensingBPM;
                        });
                        playlist = musicselect(
                            genre: genre, artist: artist, BPM: sensingBPM);
                      },
                      child: Text("前回(${previous_sensingBPM})")),
                ],
              ),
            ),

            // BPMを新規計測する部分。
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "タップでBPM計測",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        comefrom = "bpmselectpage";
                        previous_sensingBPM = sensingBPM;
                      });
                      // player.pause();
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BPMSensingPage()));
                      setState(() {});
                    },
                    child: Text("新しく登録（計測ページへ）")
                  ),
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}
