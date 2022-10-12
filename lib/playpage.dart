import 'package:beatim/BPMsensingpage.dart';
import 'package:beatim/variables.dart';
import 'package:flutter/material.dart';
import 'musicdata.dart';
import 'variables.dart';

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
                                //music = musics[playlist[index]]['filename'];
                                //ORIGINAL_BPM = musics[playlist[index]]['BPM'];
                              });
                              //_loadAudioFile();
                              //_playSoundFile();
                            }),
                        Text(musics[playlist[index]]['name']),
                      ],
                    ),
                  );
                }
              ),
            ),
            TextButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder:(context) =>BPMSensingPage()));
              setState(() {
                previous_BPM = BPM;
              });
            }, child: Text("再計測")
            ),
          ],
        ),
      ),
    );
  }
}
