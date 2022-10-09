import 'package:beatim/variables.dart';
import 'package:flutter/material.dart';
import 'musicdata.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({Key? key}) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("好きな曲を再生しよう"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ジャンル：${genre}"),
            Text("アーティスト：${artist}"),
            Text("BPM：${BPM}"),
            ListView.builder( //ここエラー出ます
              itemCount: musics.length,
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () {
                            setState(() {
                              //music = musics[index]['filename'];
                              //ORIGINAL_BPM = musics[index]['BPM'];
                            });
                            //_loadAudioFile();
                            //_playSoundFile();
                          }),
                      Text(musics[index]['name']),
                    ],
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
