import 'package:beatim/musicselectfunction.dart';
import 'package:beatim/playpage.dart';
import 'package:flutter/material.dart';
import 'variables.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Tap!'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                shape: const CircleBorder(
                  side: BorderSide(
                    color: Colors.black,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              onPressed: () {

              },
            ),
            Text("BPM:${BPM}"),
            TextButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder:(context) =>PlayPage()));
              setState(() {
                previous_BPM = BPM;
              });
              playlist = musicselect(artist: artist,BPM: BPM);
            }, child: Text("計測終了")
            ),
          ],
        ),
      ),
    );
  }
}
