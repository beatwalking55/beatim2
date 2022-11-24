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
        title: Text("BPMを設定してね",style: TextStyle(fontWeight: FontWeight.bold),),
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
                        min: min(80, previous_sensingBPM),//最小値
                        max: max(200, previous_sensingBPM),//最大値
                        onChanged: (value) {
                          setState(() {
                            sensingBPM = value;
                          });
                        }),
                  ),
                  //計算したBPMを設定してplaypageに行くボタン。
                  SizedBox(
                    width:MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      onPressed: () async{
                        setState(() {
                          sensingBPM = sensingBPM;
                          previous_sensingBPM = sensingBPM;
                        });
                        playlist = musicselect(
                            genre: genre, artist: artist, BPM: sensingBPM);
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlayPage()));
                        setState(() {
                          
                        });
                      },
                      child: Text(
                        "このBPMで走る",
                        style: TextStyle(fontSize: 30),
                      )
                    ),
                  )
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
                  SizedBox(
                    width:MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      onPressed: () async{
                        setState(() {
                          sensingBPM = sensingBPM;
                          previous_sensingBPM = previous_sensingBPM;
                        });
                        playlist = musicselect(
                            genre: genre, artist: artist, BPM: sensingBPM);
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlayPage()));
                        setState(() {

                        });
                      },
                      child: Text(
                        "前回のBPM:${previous_sensingBPM.toStringAsFixed(1)}で走る",
                        style: TextStyle(fontSize: 30),
                      )
                    ),
                  )
                ],
              ),
            ),

            //中間にある隙間。
            SizedBox(
              height: 50,
            ),

            // BPMを新規計測する部分。
            Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width:MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            comefrom = "bpmselectpage";
                            previous_sensingBPM = sensingBPM;
                          });
                          // player.pause();
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BPMSensingPage()));
                          setState(() {

                          });
                        },
                        child: Text(
                          "タップでBPM設定",
                          style: TextStyle(fontSize: 30),
                          )
                        ),
                      )
                  ]
              ),
            )
          ],
        ),
      ),
    );
  }
}
