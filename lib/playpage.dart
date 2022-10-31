import 'package:beatim/BPMsensingpage.dart';
import 'package:beatim/variables.dart';
import 'package:flutter/foundation.dart';
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

  ConcatenatingAudioSource newplaylist = ConcatenatingAudioSource(
    children:List.generate(playlist.length, (inde) => AudioSource.uri(Uri.parse('asset:${musics[playlist[inde]]['filename']}'))),
  );

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
                        onPressed: () {
                          ConcatenatingAudioSource newplaylist = ConcatenatingAudioSource(
                            children:List.generate(playlist.length, (inde) => AudioSource.uri(Uri.parse('asset:${musics[playlist[inde]]['filename']}'))),
                          );
                          setState(() {
                            visible = true;
                            music = musics[playlist[index]]['filename'];
                            ORIGINAL_musicBPM = musics[playlist[index]]['BPM'];
                            bpm_ratio = sensingBPM / ORIGINAL_musicBPM;
                            player.setSpeed(bpm_ratio);
                            changingspeed = true;
                            changingspeedbutton = "原曲";
                            playericon = Icons.pause;
                          });
                          player.setLoopMode(LoopMode.all);
                          player.setAudioSource(newplaylist,initialIndex: index,initialPosition: Duration.zero);
                          player.play();
                          setState(() {
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Flexible(
              child: Visibility(
                visible: visible,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child:StreamBuilder<int?>(
                  stream: player.currentIndexStream,
                  initialData: 0,
                  builder: (BuildContext context, snapshot){
                    return  Row(
                      children: [
                        Expanded(child: Text(musics[playlist[player.currentIndex ?? 0]]['name'], overflow: TextOverflow.ellipsis,)),
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
                          if(player.playing){
                            setState(() {
                              playericon = Icons.play_arrow;
                            });
                            player.pause();
                          }else{
                            setState(() {
                              playericon = Icons.pause;
                            });
                            player.play();
                          }
                        },
                            icon: Icon(playericon)
                        ),
                        //ここで先送りボタンを実装した
                        IconButton(
                            onPressed: (){
                              player.seekToNext();
                            },
                            icon: Icon(Icons.fast_forward))
                      ],
                    );
                  }
                )
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
            Flexible(
              child: StreamBuilder<int?>(
                stream: player.currentIndexStream,
                initialData: 0,
                builder: (BuildContext context,snapshot){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("曲ID ${playlist[snapshot.data ??0]}   ",style: TextStyle(fontSize: 30),),
                      Text("BPM  ${sensingBPM.toInt()}",style: TextStyle(fontSize: 30),),
                    ],
                  );
                }
              ),
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
Future<void> _setupSession() async {
  player = AudioPlayer();
  final session = await AudioSession.instance;
  await session.configure(AudioSessionConfiguration.speech());;
}
