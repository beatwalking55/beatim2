import 'package:beatim/musicselectfunction.dart';
import 'package:beatim/playpage.dart';
import 'package:flutter/material.dart';
import 'package:beatim/variables.dart';
import 'package:just_audio/just_audio.dart';
import 'musicdata.dart';

class BPMSensingPage extends StatefulWidget {
  const BPMSensingPage({Key? key}) : super(key: key);

  @override
  State<BPMSensingPage> createState() => _BPMSensingPageState();
}

class _BPMSensingPageState extends State<BPMSensingPage> {
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BPMを計測しよう",style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.black,
      ),
      body:Container(
        width:  double.infinity,
        height:  double.infinity,
      color: Colors.black,
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
                      children:List.generate(numberofmusics, (inde) => AudioSource.uri(Uri.parse('asset:${musics[playlist[inde]]['filename']}'))),
                    );
                    previous_sensingBPM = sensingBPM;
                    setState(() {
                      counter = 0;
                    });
                  }
                  );
                  if(comefrom == "playpage"){
                    player.pause();
                    player.setLoopMode(LoopMode.all);//ループ再生on
                    player.setAudioSource(newplaylist,initialIndex: 0,initialPosition: Duration.zero);//index番目の曲をplayerにセット
                    player.play();
                    player.setSpeed(sensingBPM/musics[playlist[0]]['BPM']);
                    bpm_ratio = sensingBPM/musics[playlist[0]]['BPM'];
                    comefrom = "BPMsensingpage";
                    Navigator.pop(context);
                  }else{
                    bpm_ratio = sensingBPM/musics[playlist[0]]['BPM'];
                    comefrom = "BPMsensingpage";
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PlayPage()));
                  }
                }
              },

        child: Stack(
          alignment: Alignment.center,


          children:<Widget>[ 
      Positioned(
        top: 300.0,
            child: Column(
              children: [
                Text("走るリズムに合わせて\n画面を6回タップ",style: TextStyle(fontSize: 30, color: Colors.white),),
                Text("BPM:${sensingBPM}",style: TextStyle(fontSize: 30, color: Colors.white),),
              ],
            ),
          ),  
            // TextButton(
            //     onPressed: () {
            //       Navigator.pop(context);
            //       setState(() {
            //         player.setSpeed(bpm_ratio);
            //         changingspeed = true;
            //         changingspeedbutton = "原曲";
            //         previous_sensingBPM = sensingBPM;
            //         playlist = musicselect(genre:genre, artist: artist, BPM: sensingBPM);
            //       });
            //     },
            //     child: Text("計測終了")
            //     ),
              
            ],
          ),  
      ),
      ),
    );
  }
}
