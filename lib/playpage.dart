import 'package:beatim/BPMsensingpage.dart';
import 'package:beatim/variables.dart';
import 'package:flutter/material.dart';
import 'package:beatim/musicdata.dart';
import 'package:beatim/variables.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:url_launcher/url_launcher.dart';

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
            Flexible(
              child: ListView.builder(
                itemCount: playlist.length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    alignment:Alignment.centerLeft,
                    child: Container(
                      width:double.infinity,
                      child:ElevatedButton.icon(
                        icon: Icon(Icons.play_arrow),
                        label: Text(musics[playlist[index]]['name']),
                        onPressed: () async{
                          setState(() {
                            visible = true;
                            playingmusic = index;
                            playericon = Icons.pause;
                            music = musics[playlist[index]]['filename'];
                            ORIGINAL_musicBPM = musics[playlist[index]]['BPM'];
                            bpm_ratio = sensingBPM / ORIGINAL_musicBPM;
                            player.setSpeed(bpm_ratio);
                            changingspeed = true;
                            changingspeedbutton = "原曲";
                          });
                          player.setLoopMode(LoopMode.all);
                          final newplaylist = ConcatenatingAudioSource(
                            children:List.generate(playlist.length, (inde) => AudioSource.uri(Uri.parse('asset:${musics[playlist[inde]]['filename']}'))),
                          );
                          await player.setAudioSource(newplaylist,initialIndex: index,initialPosition: Duration.zero);
                          player.play();
                          // _loadAudioFile();
                          // _playSoundFile();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: visible,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Row(
                children: [
                  Expanded(child: Text(musics[playlist[playingmusic]]['name'], overflow: TextOverflow.ellipsis,)),
                  TextButton(
                      onPressed:(){ setState(() {
                        if(changingspeed == true){
                          changingspeed = false;
                          player.setSpeed(1.0);
                          changingspeedbutton = "走速";
                        }else{
                          changingspeed = true;
                          player.setSpeed(bpm_ratio);
                          changingspeedbutton = "原曲";
                        }
                      });},
                      child: Text(changingspeedbutton)),
                  IconButton(onPressed:(){
                    if(playericon == Icons.play_arrow){
                      setState(() {
                        playericon = Icons.pause;
                        music = musics[playlist[playingmusic]]['filename'];
                      });
                      _playSoundFile();
                    }else{
                      player.pause();
                      setState(() {
                        playericon = Icons.play_arrow;
                      });
                    }
                  },
                      icon: Icon(playericon)
                  ),
                  //ここで先送りボタンを実装したかった
                  IconButton(
                      onPressed: (){
                        player.seekToNext();
                      },
                      icon: Icon(Icons.fast_forward))
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
              // player.pause();
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder:(context) => BPMSensingPage()
                  )
              );
              setState(() {
                comefrom = "playpage";
                previous_sensingBPM = sensingBPM;
              });
            }, child: Text("再計測")
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("曲ID ${playlist[playingmusic]}   ",style: TextStyle(fontSize: 30),),
                Text("BPM  ${sensingBPM.toInt()}",style: TextStyle(fontSize: 30),),
              ],
            ),
            TextButton(
                onPressed:()async{
                  if (await canLaunch('https://docs.google.com/forms/d/e/1FAIpQLSdHaYCO4SPZdX85eiUK9luVBR3NATbVb2WmdTkRf-Ml0neRgg/viewform?usp=sf_link')) {
                    await launch(
                      'https://docs.google.com/forms/d/e/1FAIpQLSdHaYCO4SPZdX85eiUK9luVBR3NATbVb2WmdTkRf-Ml0neRgg/viewform?usp=sf_link',
                      forceSafariVC: false,
                      //forceWebView: true,
                    );
                  } else {
                    throw 'このURLにはアクセスできません';
                  }
                },
                child: Text("評価フォームへ")),
            // Visibility(
            //   visible: visible,
            //   maintainSize: true,
            //   maintainAnimation: true,
            //   maintainState: true,
            //   child: TextButton(onPressed: () async {
            //     // player.pause();
            //     await Navigator.of(context).push(
            //         MaterialPageRoute(
            //             builder:(context) => logpage()
            //         )
            //     );
            //   }, child: Text("評価ページへ")
            //   ),
            // ),
            SizedBox(height: 15,)
          ],
        ),
      ),
    );
  }
}

late AudioPlayer player;
bool _changeAudioSource = false;


Future<void> _setupSession() async {
  player = AudioPlayer();
  final session = await AudioSession.instance;
  await session.configure(AudioSessionConfiguration.speech());
  await _loadAudioFile();
}

Future<void> _loadAudioFile() async {
  try {
    await player.setAsset(music);
  } catch(e) {
    print(e);
  }
}

Future<void> _playSoundFile() async {
  // 再生終了状態の場合、新たなオーディオファイルを定義し再生できる状態にする
  if(player.processingState == ProcessingState.completed) {
    await _loadAudioFile();
  }
  await player.play();
}