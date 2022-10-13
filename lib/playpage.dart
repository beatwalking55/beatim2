import 'package:beatim/BPMsensingpage.dart';
import 'package:beatim/variables.dart';
import 'package:flutter/material.dart';
import 'musicdata.dart';
import 'variables.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

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
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("ジャンル：${genre}"),
              Text("アーティスト：${artist}"),
              Text("BPM：${BPM}"),
              Flexible(
                child: ListView.builder(
                  itemCount: playlist.length,
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () {
                                setState(() {
                                  playingmusic = index;
                                  playericon = Icons.pause;
                                  music = musics[playlist[index]]['filename'];
                                  visible = true;
                                  //ORIGINAL_BPM = musics[playlist[index]]['BPM'];
                                });
                                _loadAudioFile();
                                _playSoundFile();
                              }),
                          Expanded(
                              child: Text(musics[playlist[index]]['name'],overflow: TextOverflow.ellipsis,),
                          ),

                        ],
                      ),
                    );
                  }
                ),
              ),
              TextButton(onPressed: () {
                //player.pause();
                Navigator.push(context,MaterialPageRoute(builder:(context) =>BPMSensingPage()));
                setState(() {
                  previous_BPM = BPM;
                });
              }, child: Text("再計測")
              ),
              Visibility(
                visible: visible,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Row(
                  children: [
                      Expanded(child: Text(musics[playlist[playingmusic]]['name'], overflow: TextOverflow.ellipsis,)),
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
                            player.pause();
                            setState(() {
                              if(playingmusic == playlist.length-1){
                                playingmusic = 0;
                              }else{
                                playingmusic += 1;
                              }
                              music = musics[playlist[playingmusic]]['filename'];
                            });
                            _loadAudioFile();
                            if (playericon == Icons.pause){
                              _playSoundFile();
                            }
                          },
                          icon: Icon(Icons.fast_forward))
                    ],
                  ),
                ),
            ],
          ),
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

  //await _player.setSpeed(_currentSliderValue); // 再生速度を指定
  await player.play();
}