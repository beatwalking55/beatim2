import 'package:beatim/variables.dart';
import 'package:flutter/material.dart';
import 'package:beatim/musicdata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:beatim/musicselectfunction.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:beatim/common.dart';

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
    // AudioPlayerの状態を取得
    player.playbackEventStream.listen((event) {
      switch (event.processingState) {
        case ProcessingState.idle:
          debugPrint('オーディオファイルをロードしていないよ');
          break;
        case ProcessingState.loading:
          debugPrint('オーディオファイルをロード中だよ');
          break;
        case ProcessingState.buffering:
          debugPrint('バッファリング(読み込み)中だよ');
          break;
        case ProcessingState.ready:
          debugPrint('再生できるよ');
          debugPrint('index: ${player.currentIndex.toString()}');
          break;
        case ProcessingState.completed:
          debugPrint('再生終了したよ');
          break;
        default:
          debugPrint(event.processingState.toString());
          break;
      }
    });
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

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, //上のバーの背景色
        title: const Text(
          "Playlist",
          style: TextStyle(fontWeight: FontWeight.bold),
        ), //上のバーのテキスト
      ),
      body: Container(
        color: Colors.black, //画面の背景色
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //曲を選んで再生する部分。
              Flexible(
                child: ListView.builder(
                  itemCount: playlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom:  BorderSide(
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

                        child: Text(
                          "${musics[playlist[index]]['name']}",
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 17),
                          overflow: TextOverflow.ellipsis,
                        ), //曲名
                        onPressed: () async {
                          //タップされた時の処理
                          await player.setLoopMode(LoopMode.all); //ループ再生on
                          await player.seek(Duration.zero,index: index);//index番目の曲にスキップ
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
                            child:
                              Text(
                              musics[playlist[player.currentIndex ?? 0]]['name'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 30, color: Colors.white),
                            ) //現在再生している曲
                          ),
                          ControlButtons(player),
                          StreamBuilder<PositionData>(
                            stream: _positionDataStream,
                            builder: (context, snapshot) {
                              final positionData = snapshot.data;
                              return SeekBar(
                                duration: positionData?.duration ?? Duration.zero,
                                position: positionData?.position ?? Duration.zero,
                                bufferedPosition:
                                    positionData?.bufferedPosition ?? Duration.zero,
                                onChangeEnd: (newPosition) {
                                  player.seek(newPosition);
                                },
                              );
                            },
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
                    SizedBox(
                      //左右のバランスを取るための空箱。何か要素を入れることも可能。
                      width: 60, //幅
                      height: 60, //高さ
                      child: Text(
                        "${counter.toStringAsFixed(0)}/${(duls.length + 1).toStringAsFixed(0)}",
                        style: const TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                    //BPM計測ボタン
                    Container(
                      //外側の四角
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), //角丸にする
                        gradient: const LinearGradient(
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
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              oldtime = newtime;
                              newtime = DateTime.now()
                                  .millisecondsSinceEpoch; //millisecond
                              for (int i = duls.length - 1; i > 0; i--) {
                                duls[i] = duls[i - 1];
                              }
                              duls[0] = newtime - oldtime;
                              double aveDul = (duls.reduce((a, b) => a + b) -
                                      duls.reduce(max) -
                                      duls.reduce(min)) /
                                  (duls.length - 2);
                              setState(() {
                                sensingBPM = 60.0 / (aveDul / 1000);
                              });
                              counter += 1;
                              if (counter == duls.length + 1) {
                                HapticFeedback.vibrate();
                                setState(() {
                                  playlist = musicselect(
                                      genre: genre,
                                      artist: artist,
                                      BPM: sensingBPM);
                                  newplaylist = ConcatenatingAudioSource(
                                    children: List.generate(
                                        playlist.length,
                                        (inde) => AudioSource.uri(Uri.parse(
                                            musics[playlist[inde]]
                                                ['filename']))),
                                  );
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
                                adjustSpeed();
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
                                      const Padding(
                                        padding: EdgeInsets.all(
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
                                          style: const TextStyle(
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
                    SizedBox(
                      //左右のバランスを取るための空箱。
                      width: 60, //幅
                      height: 120, //高さ
                      child: Column(
                          //内側の四角
                          children: [
                            SizedBox(
                              width: 30, //幅
                              height: 30, //高さ
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    sensingBPM = (sensingBPM + 1).toInt().toDouble();
                                    adjustSpeed();
                                  });
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: const <Widget>[
                                    Positioned(
                                      top: 1.0,
                                      child: 
                                           Padding(
                                            padding: EdgeInsets.all(
                                                1.0), //走る人マーク周りの余白
                                            child: Icon(Icons.add,
                                                color: Colors.white,
                                                size: 30), //プラスのマーク
                                          ),
                                        
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                            ),
                            SizedBox(
                              width: 30, //幅
                              height: 30, //高さ
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    sensingBPM = (sensingBPM - 1).toInt().toDouble();
                                    adjustSpeed();
                                  });
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: const <Widget>[
                                    Positioned(
                                      top: 1.0,
                                      child: 
                                          Padding(
                                            padding: EdgeInsets.all(
                                                1.0), //走る人マーク周りの余白
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                              size: 30,
                                            ), //マイナスのマーク
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 30), //スライドバー周りの余白
                child: Transform.rotate(
                  angle: 0,
                  child: Slider(
                      inactiveColor: Colors.blue.shade50, //左側の色
                      activeColor: Colors.pinkAccent, //右側の色
                      thumbColor: Colors.pinkAccent, //バーの丸いやつの色
                      value: sensingBPM, //バーの初期値を設定
                      min: min(80, sensingBPM), //最小値
                      max: max(200, sensingBPM), //最大値
                      divisions: 120,
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          sensingBPM = value;
                          adjustSpeed();
                        });
                      }),
                ),
              )

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
  await session.configure(const AudioSessionConfiguration.speech());
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.volume_up, color: Colors.white),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
              icon: const Icon(Icons.skip_previous, color: Colors.white),
              onPressed: () async {
                await player.seekToPrevious();
              }),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (previousIndex != player.currentIndex) {
              debugPrint('prev: ${previousIndex.toString()}');
              adjustSpeed();
              previousIndex = player.currentIndex;
            }
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(color: Colors.white),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause, color: Colors.white),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay, color: Colors.white),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
              icon: const Icon(Icons.skip_next, color: Colors.white),
              onPressed: () async {
                await player.seekToNext();
              }),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text(
              "${snapshot.data?.toStringAsFixed(2)}x",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;
  final double bpm;

  AudioMetadata({
    required this.album,
    required this.title,
    required this.artwork,
    required this.bpm,
  });
}

adjustSpeed() {
  player.setSpeed(sensingBPM / musics[playlist[player.currentIndex ?? 0]]['BPM']);
}