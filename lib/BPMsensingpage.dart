import 'package:beatim/musicselectfunction.dart';
import 'package:beatim/playpage.dart';
import 'package:flutter/material.dart';
import 'package:beatim/variables.dart';

class BPMSensingPage extends StatefulWidget {
  const BPMSensingPage({Key? key}) : super(key: key);

  @override
  State<BPMSensingPage> createState() => _BPMSensingPageState();
}

class _BPMSensingPageState extends State<BPMSensingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BPMを計測しよう"),
      ),
      body:         Container(
        width:  double.infinity,
        height:  double.infinity,
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
                print(bpm_ratio);
              },
          

            //ElevatedButton(
              //child: const Text('Tap!'),
              //style: ElevatedButton.styleFrom(
                //primary: Colors.white,
                //onPrimary: Colors.black,
                //shape: const CircleBorder(
                  //side: BorderSide(
                    //color: Colors.black,
                    //width: 1,
                    //style: BorderStyle.solid,
                  //),
                //),
              //),


        child: Stack(
          alignment: Alignment.center,


          children:<Widget>[ 
      Positioned(
        top: 300.0,
            child: Text("BPM:${sensingBPM}"),
          ),  
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    player.setSpeed(bpm_ratio);
                    previous_sensingBPM = sensingBPM;
                    playlist = musicselect(artist: artist, BPM: sensingBPM);
                  });
                },
                child: Text("計測終了")
                ),
              
            ],
          ),  
      ),
      ),
    );
  }
}
