import 'package:beatim/BPMsensingpage.dart';
import 'package:beatim/variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:beatim/musicdata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'logpage.dart';

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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("好きな曲を再生しよう"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ジャンル：${genre}",),
            Text("アーティスト：${artist}"),
            Text("BPM：${sensingBPM}"),
            //曲を選んで再生する部分。
            Flexible(
              child: ListView.builder(
                itemCount: playlist.length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    alignment:Alignment.centerLeft,
                    child: Container(
                      width:double.infinity,
                      child:ElevatedButton.icon(
                        icon: Icon(Icons.play_arrow),//再生マーク
                        label: Text(musics[playlist[index]]['name']),//曲名
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
              child: Visibility(//表示・非表示を切り替えられる
                visible: visible,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child:StreamBuilder<int?>(//常に最新状態を描画してくれる
                  stream: player.currentIndexStream,
                  initialData: 0,
                  builder: (BuildContext context, snapshot){
                    return  Row(
                      children: [
                        Expanded(child: Text(musics[playlist[player.currentIndex ?? 0]]['name'], overflow: TextOverflow.ellipsis,)),

                        //原曲・走る速度切り替えボタン
                        TextButton(
                            onPressed:(){ setState(() {
                              if(changingspeed == true){
                                changingspeed = false;
                                player.setSpeed(1.0);
                                changingspeedbutton = "走速";
                              }else{
                                changingspeed = true;
                                player.setSpeed(sensingBPM/musics[playlist[player.currentIndex ?? 0]]['BPM']);
                                changingspeedbutton = "原曲";
                              }
                            });},
                            child: Text(changingspeedbutton),
                        ),

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
                            icon: Icon(_playericon)
                        ),
                        //先送りボタン
                        IconButton(
                            onPressed: () {
                              player.seekToNext();
                              setState(() {

                              });
                            },
                            icon: Icon(Icons.fast_forward))
                      ],
                    );
                  }
                )
              ),
            ),

            //BPMを再計測するページに行くボタン。
            TextButton(
              onPressed: () async {
                comefrom = "playpage";
              // player.pause();
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder:(context) => BPMSensingPage()
                  )
              );
              setState(() {
                previous_sensingBPM = sensingBPM;
              });
            }, child: Text("再計測")
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
             Visibility(
               visible: visible,
               maintainSize: true,
               maintainAnimation: true,
               maintainState: true,
               child: TextButton(onPressed: () async {
                 // player.pause();
                 await Navigator.of(context).push(
                     MaterialPageRoute(
                         builder:(context) => logpage()
                     )
                 );
               }, child: Text("評価ページへ")
               ),
             ),
            SizedBox(height: 15,)
          ],
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
