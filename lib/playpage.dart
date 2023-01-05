import 'package:beatim/variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:beatim/musicdata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:beatim/musicselectfunction.dart';
import 'dart:math';

class PlayPage extends StatefulWidget {
  const PlayPage({Key? key}) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  @override
  void initState() {
    super.initState;
    _setupSession();
  }

  //このコードがあると画面遷移時に音楽が止まる。
  //逆にこのコードを消すと、画面遷移しても音楽は止まらないが再生ボタンを押すたびに音楽が止まらずに次々流れてカオスになる。
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  //プレイリストを最初に生成。
  ConcatenatingAudioSource newplaylist = ConcatenatingAudioSource(
    children: List.generate(
        playlist.length,
        (inde) =>
            AudioSource.uri(Uri.parse(musics[playlist[inde]]['filename']))),
  );

  var _playericon =
      Icons.play_arrow; //playpageの下の方に表示されるマーク play_arrow:再生マーク　pause:停止マーク
  int counter = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, //上のバーの背景色
        title: Text(
          "曲を再生しよう",
          style: TextStyle(fontWeight: FontWeight.bold),
        ), //上のバーのテキスト
      ),
      body: Container(
        color: Colors.black, //画面の背景色
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text("ジャンル：${genre}",),
              // Text("アーティスト：${artist}"),
              // Text("BPM：${sensingBPM}"),
              //曲を選んで再生する部分。
              Flexible(
                child: ListView.builder(
                  itemCount: playlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: const BorderSide(
                            color: Colors.white30), //ボタンの下のみにボーダーラインを設定
                      )),
                      width: double.infinity, //幅を最大限にする
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(0)), //ボタンの角をつける
                          backgroundColor: Colors.black, //ボタンの背景色
                        ),
                        // icon: Icon(Icons.play_arrow),//再生マーク
                        child: Text(
                          "${musics[playlist[index]]['name']}",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 17),
                          overflow: TextOverflow.ellipsis,
                        ), //曲名
                        onPressed: () {
                          //タップされた時の処理
                          setState(() {
                            newplaylist = ConcatenatingAudioSource(
                              children: List.generate(
                                  playlist.length,
                                  (inde) => AudioSource.uri(Uri.parse(
                                      musics[playlist[inde]]['filename']))),
                            );
                            visible = true; //下の再生バーを表示する
                            music = musics[playlist[index]]
                                ['filename']; //曲のファイル名を指定
                            ORIGINAL_musicBPM =
                                musics[playlist[index]]['BPM']; //曲のBPMを指定
                            bpm_ratio =
                                sensingBPM / ORIGINAL_musicBPM; //再生スピードを指定
                            player.setSpeed(
                                sensingBPM / ORIGINAL_musicBPM); //再生スピードを設定・
                            changingspeed = true; //変速していることを示す
                            changingspeedbutton =
                                "原曲"; //再生バーの表示を変更（最初は走る速度で再生するから、「原曲」ボタンになる）
                            _playericon =
                                Icons.pause; //再生バーのアイコン(再生時には「停止」マークになる)
                          });
                          player.setLoopMode(LoopMode.all); //ループ再生on
                          player.setAudioSource(newplaylist,
                              initialIndex: index,
                              initialPosition:
                                  Duration.zero); //index番目の曲をplayerにセット
                          player.play(); //playerを再生
                          setState(() {}); //再描画
                        },
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                child: StreamBuilder<int?>(
                    //常に最新状態を描画してくれる
                    stream: player.currentIndexStream, //受け取る情報
                    initialData: 0, //最初のすうじ
                    builder: (BuildContext context, snapshot) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0), //再生曲名の余白
                            child: Container(
                                child: Text(
                              musics[playlist[player.currentIndex ?? 0]]
                                  ['name'],
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 40, color: Colors.white),
                            ) //現在再生している曲
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0), //再生速度周りの余白
                            child: Container(
                              child: Text(
                                "再生速度:×${bpm_ratio.toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ), //現在の再生速度
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 15,
                                0), //再生ボタン周りの余白。少し右に余白をとり全体を左に寄せるとバランスよく見える。
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //頭出しボタン
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0), //頭出しボタン周りの余白
                                  child: IconButton(
                                      onPressed: () async {
                                        await player.seekToPrevious();
                                        setState(() {});
                                        bpm_ratio = sensingBPM / musics[playlist[player.currentIndex ?? 0]]['BPM'];
                                        player.setSpeed(bpm_ratio);
                                      },
                                      icon: Icon(
                                        Icons.fast_rewind,
                                        color: Colors.white,
                                        size: 50,
                                      ) //頭出しボタンのアイコン
                                      ),
                                ),
                                //再生・停止ボタン・
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      50, 0, 50, 0), //再生・停止ボタン周りの余白
                                  child: IconButton(
                                      onPressed: () {
                                        if (player.playing) {
                                          setState(() {
                                            _playericon = Icons.play_arrow;
                                          });
                                          player.pause();
                                        } else {
                                          setState(() {
                                            _playericon = Icons.pause;
                                          });
                                          player.play();
                                        }
                                      },
                                      icon: Icon(
                                        _playericon,
                                        color: Colors.white,
                                        size: 50,
                                      ) //再生・停止ボタンのアイコン
                                      ),
                                ),
                                //先送りボタン
                                IconButton(
                                    onPressed: () async {
                                      await player.seekToNext();
                                      setState(() {});
                                      bpm_ratio = sensingBPM / musics[playlist[player.currentIndex ?? 0]]['BPM'];
                                      print(player.currentIndex);
                                      player.setSpeed(bpm_ratio);
                                    },
                                    icon: Icon(
                                      Icons.fast_forward,
                                      color: Colors.white,
                                      size: 50,
                                    ) //先送りボタンのアイコン
                                    )
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              ),

              Padding(
                padding:
                    const EdgeInsets.fromLTRB(10, 50, 10, 10), //BPM計測ボタン周りの余白
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      //左右のバランスを取るための空箱。何か要素を入れることも可能。
                      width: 60, //幅
                      height: 60, //高さ
                      //原曲・走る速度切り替えボタン(現在非表示)
                      // child: TextButton(
                      //   onPressed:(){ setState(() {
                      //     if(changingspeed == true){
                      //       changingspeed = false;
                      //       player.setSpeed(1.0);
                      //       changingspeedbutton = "走速";
                      //     }else{
                      //       changingspeed = true;
                      //       player.setSpeed(sensingBPM/musics[playlist[player.currentIndex ?? 0]]['BPM']);
                      //       changingspeedbutton = "原曲";
                      //     }
                      //   });},
                      //   child: Text(changingspeedbutton),
                      //),
                    ),
                    //BPM計測ボタン
                    Container(
                      //外側の四角
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), //角丸にする
                        gradient: LinearGradient(
                            //グラデーション設定
                            begin: FractionalOffset.topLeft, //グラデーション開始位置
                            end: FractionalOffset.bottomRight, //グラデーション終了位置
                            colors: [
                              Colors.pinkAccent, //グラデーション開始色
                              Colors.purple, //グラデーション終了色
                            ]),
                      ),
                      width: 200, //幅
                      height: 200, //高さ
                      child: Center(
                        //内側の四角
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5), //角丸にする
                            color: Colors.black, //色
                          ),
                          width: 170, //幅
                          height: 170, //高さ
                          child: GestureDetector(
                            //BPMsensingpageのものとほぼ同じ
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              oldtime = newtime;
                              newtime = DateTime.now()
                                  .millisecondsSinceEpoch; //millisecond
                              for (int i = duls.length - 1; i > 0; i--) {
                                duls[i] = duls[i - 1];
                              }
                              duls[0] = newtime - oldtime;
                              double ave_dul = (duls.reduce((a, b) => a + b) -
                                      duls.reduce(max) -
                                      duls.reduce(min)) /
                                  (duls.length - 2);
                              setState(() {
                                sensingBPM = 60.0 / (ave_dul / 1000);
                              });
                              bpm_ratio = sensingBPM / ORIGINAL_musicBPM;
                              counter += 1;
                              if (counter == duls.length + 1) {
                                setState(() {
                                  _playericon = Icons.pause;
                                  playlist = musicselect(
                                      genre: genre,
                                      artist: artist,
                                      BPM: sensingBPM);
                                  changingspeed = true;
                                  changingspeedbutton = "原曲";
                                  newplaylist = ConcatenatingAudioSource(
                                    children: List.generate(
                                        playlist.length,
                                        (inde) => AudioSource.uri(Uri.parse(
                                            musics[playlist[inde]]
                                                ['filename']))),
                                  );
                                  previous_sensingBPM = sensingBPM;
                                  setState(() {
                                    counter = 0;
                                  });
                                });
                                player.pause();
                                player.setLoopMode(LoopMode.all); //ループ再生on
                                player.setAudioSource(newplaylist,
                                    initialIndex: 0,
                                    initialPosition:
                                        Duration.zero); //index番目の曲をplayerにセット
                                player.play();
                                player.setSpeed(
                                    sensingBPM / musics[playlist[0]]['BPM']);
                                bpm_ratio =
                                    sensingBPM / musics[playlist[0]]['BPM'];
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Positioned(
                                  top: 10.0,
                                  child: Column(
                                    //ボタンの中身
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(
                                            4.0), //走る人マーク周りの余白
                                        child: Icon(
                                          Icons.directions_run,
                                          color: Colors.white,
                                          size: 100,
                                        ), //走る人のマーク
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            2, 15, 2, 2), //現在のBPM周りの余白
                                        child: Text(
                                          "BPM${sensingBPM.toStringAsFixed(1)}",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white),
                                        ), //現在のBPM
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      //左右のバランスを取るための空箱。
                      width: 60, //幅
                      height: 60, //高さ
                      child: Text(
                        "${counter.toStringAsFixed(0)}/${(duls.length + 1).toStringAsFixed(0)}",
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(10, 0, 10, 10), //BPM計測ボタン周りの余白
                child: Transform.rotate(
                  angle: 0,
                  child: Slider(
                      inactiveColor: Colors.blue.shade50, //左側の色
                      activeColor: Colors.pinkAccent, //右側の色
                      thumbColor: Colors.pinkAccent, //バーの丸いやつの色
                      value: sensingBPM, //バーの初期値を設定
                      min: min(80, sensingBPM), //最小値
                      max: max(200, sensingBPM), //最大値
                      onChanged: (value) {
                        setState(() {
                          previous_sensingBPM = sensingBPM;
                          sensingBPM = value;
                          bpm_ratio = sensingBPM / musics[playlist[0]]['BPM'];
                          player.setSpeed(
                              sensingBPM / musics[playlist[0]]['BPM']);
                        });
                      }),
                ),
              )
              //曲IDとBPMを表示する。
              // Flexible(
              //   child: StreamBuilder<int?>(
              //     stream: player.currentIndexStream,
              //     initialData: 0,
              //     builder: (BuildContext context,snapshot){
              //       return Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text("曲ID ${playlist[snapshot.data ??0]}   ",style: TextStyle(fontSize: 30),),
              //           Text("BPM  ${sensingBPM.toInt()}",style: TextStyle(fontSize: 30),),
              //         ],
              //       );
              //     }
              //   ),
              // ),
              //評価フォームへのリンクを画面に表示。
              // TextButton(
              //     onPressed:()async{
              //       if (await canLaunch('https://docs.google.com/forms/d/e/1FAIpQLSdHaYCO4SPZdX85eiUK9luVBR3NATbVb2WmdTkRf-Ml0neRgg/viewform?usp=sf_link')) {
              //         await launch(
              //           'https://docs.google.com/forms/d/e/1FAIpQLSdHaYCO4SPZdX85eiUK9luVBR3NATbVb2WmdTkRf-Ml0neRgg/viewform?usp=sf_link',
              //           forceSafariVC: false,
              //           //forceWebView: true,
              //         );
              //       } else {
              //         throw 'このURLにはアクセスできません';
              //       }
              //     },
              //child: Text("評価フォームへ")),

              //評価ページに行くボタン。一曲目が再生されるまで表示されない。
              //  Visibility(
              //    visible: visible,
              //    maintainSize: true,
              //    maintainAnimation: true,
              //    maintainState: true,
              //    child: TextButton(onPressed: () async {
              //      // player.pause();
              //      await Navigator.of(context).push(
              //          MaterialPageRoute(
              //              builder:(context) => logpage()
              //          )
              //      );
              //    }, child: Text("評価ページへ",style: TextStyle(fontSize: 20),)
              //    ),
              //  ),
              //SizedBox(height: 15,)
            ],
          ),
        ),
      ),
    );
  }
}

late AudioPlayer player;
Future<void> _setupSession() async {
  player = AudioPlayer();
  final session = await AudioSession.instance;
  await session.configure(AudioSessionConfiguration.speech());
  ;
}
