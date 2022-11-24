import 'package:beatim/BPMsensingpage.dart';
import 'package:beatim/variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:beatim/musicdata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'logpage.dart';
import 'package:beatim/musicselectfunction.dart';

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
    children:List.generate(playlist.length, (inde) => AudioSource.uri(Uri.parse('asset:${musics[playlist[inde]]['filename']}'))),
  );

  var _playericon = Icons.play_arrow; //playpageの下の方に表示されるマーク play_arrow:再生マーク　pause:停止マーク
  int counter = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("好きな曲を再生しよう",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Container(
        color: Colors.black,
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
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      alignment: Alignment.center,
                      child: Container(
                        width:MediaQuery.of(context).size.width * 0.9,
                        child:ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          // icon: Icon(Icons.play_arrow),//再生マーク
                          child: Text(musics[playlist[index]]['name']),//曲名
                          onPressed: () {
                            //タップされた時の処理
                            setState(() {
                              newplaylist = ConcatenatingAudioSource(
                                children:List.generate(playlist.length, (inde) => AudioSource.uri(Uri.parse('asset:${musics[playlist[inde]]['filename']}'))),
                              );
                              visible = true;//下の再生バーを表示する
                              music = musics[playlist[index]]['filename'];//曲のファイル名を指定
                              ORIGINAL_musicBPM = musics[playlist[index]]['BPM'];//曲のBPMを指定
                              bpm_ratio = sensingBPM / ORIGINAL_musicBPM;//再生スピードを指定
                              player.setSpeed(sensingBPM/ORIGINAL_musicBPM);//再生スピードを設定・
                              changingspeed = true;//変速していることを示す
                              changingspeedbutton = "原曲";//再生バーの表示を変更（最初は走る速度で再生するから、「原曲」ボタンになる）
                              _playericon = Icons.pause;//再生バーのアイコン(再生時には「停止」マークになる)
                            });
                            player.setLoopMode(LoopMode.all);//ループ再生on
                            player.setAudioSource(newplaylist,initialIndex: index,initialPosition: Duration.zero);//index番目の曲をplayerにセット
                            player.play();//playerを再生
                            setState(() {
                            });//再描画
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                child: StreamBuilder<int?>(//常に最新状態を描画してくれる
                  stream: player.currentIndexStream,
                  initialData: 0,
                  builder: (BuildContext context, snapshot){
                    return  Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Text(musics[playlist[player.currentIndex ?? 0]]['name'], overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 30, color: Colors.white),)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            child: Text("再生速度:×${bpm_ratio.toStringAsFixed(2)}",style: TextStyle(color: Colors.white),),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //前送りボタン
                              IconButton(
                                  onPressed:(){
                                    player.seekToPrevious();
                                    setState(() {});
                                    bpm_ratio = sensingBPM/musics[playlist[player.currentIndex ?? 0]]['BPM'];
                                    player.setSpeed(bpm_ratio);
                                  }, icon: Icon(Icons.fast_rewind, color: Colors.white,size: 50,)),
                              //再生・停止ボタン・
                              IconButton(onPressed:(){
                                if(player.playing){
                                  setState(() {
                                    _playericon = Icons.play_arrow;
                                  });
                                  player.pause();
                                }else{
                                  setState(() {
                                    _playericon = Icons.pause;
                                  });
                                  player.play();
                                }
                              },
                                  icon: Icon(_playericon, color: Colors.white,size: 50,)
                              ),
                              //先送りボタン
                              IconButton(
                                  onPressed: () {
                                    player.seekToNext();
                                    setState(() {

                                    });
                                    bpm_ratio = sensingBPM/musics[playlist[player.currentIndex ?? 0]]['BPM'];
                                    player.setSpeed(bpm_ratio);
                                  },
                                  icon: Icon(Icons.fast_forward, color: Colors.white,size: 50,))
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //原曲・走る速度切り替えボタン
                    Container(
                      width: 60,
                      height: 60,
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
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin:FractionalOffset.topLeft,
                          end: FractionalOffset.bottomRight,
                          colors: [
                            Colors.pinkAccent,
                            Colors.purple,
                          ]
                        ),
                      ),
                      width:180,
                      height: 180,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black,
                          ),
                          width: 150,
                          height: 150,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              oldtime = newtime;
                              newtime = DateTime.now().millisecondsSinceEpoch; //millisecond
                              duls[4] = duls[3];
                              duls[3] = duls[2];
                              duls[2] = duls[1];
                              duls[1] = duls[0];
                              duls[0] = newtime - oldtime;
                              double ave_dul = duls.reduce((a, b) => a + b) / duls.length;
                              setState(() {
                                sensingBPM = 60.0 / (ave_dul / 1000);
                              });
                              bpm_ratio = sensingBPM / ORIGINAL_musicBPM;
                              counter += 1;
                              if (counter == 6){
                                setState(() {
                                  playlist = musicselect(genre:genre, artist: artist, BPM: sensingBPM);
                                  changingspeed = true;
                                  changingspeedbutton = "原曲";
                                  newplaylist = ConcatenatingAudioSource(
                                    children:List.generate(playlist.length, (inde) => AudioSource.uri(Uri.parse('asset:${musics[playlist[inde]]['filename']}'))),
                                  );
                                  previous_sensingBPM = sensingBPM;
                                  setState(() {
                                    counter = 0;
                                  });
                                }
                                );
                                player.pause();
                                player.setLoopMode(LoopMode.all);//ループ再生on
                                player.setAudioSource(newplaylist,initialIndex: 0,initialPosition: Duration.zero);//index番目の曲をplayerにセット
                                player.play();
                                player.setSpeed(sensingBPM/musics[playlist[0]]['BPM']);
                                bpm_ratio = sensingBPM/musics[playlist[0]]['BPM'];
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children:<Widget>[
                                Positioned(
                                  top: 10.0,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Icon(Icons.directions_run, color: Colors.white,size: 100,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(2, 10, 2, 2),
                                        child: Text("BPM:${sensingBPM.toStringAsFixed(1)}",style: TextStyle(fontSize: 20, color: Colors.white),),
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
                      width: 60,
                      height: 60,
                    )
                  ],
                ),
              ),
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
  await session.configure(AudioSessionConfiguration.speech());;
}
