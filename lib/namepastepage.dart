import 'package:beatim/startpage.dart';
import 'package:beatim/variables.dart';
import 'package:flutter/material.dart';
import 'musicdata.dart';

class inputnamepage extends StatefulWidget {
  const inputnamepage({Key? key}) : super(key: key);

  @override
  State<inputnamepage> createState() => _inputnamepageState();
}

class _inputnamepageState extends State<inputnamepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("曲名とBPMを入力",
            style: TextStyle(
              color: Colors.black
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "曲名",
                  ),
                  onChanged:(text){
                    musicname = text;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "BPM",
                  ),
                  onChanged:(text){
                    if(text != ""){
                      musics[0]['BPM'] = double.parse(text);
                    }else{
                      musics[0]['BPM'] = 185;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.black,
                    )
                  ),
                    onPressed:(){
                      setState(() {
                        inputname(musicname);
                      });
                      Navigator.push(context, MaterialPageRoute(builder:(context) => startpage()));
                    },
                    child: Text("次へ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30
                      ),
                    )
                ),
              )
            ],
          ),

        ),
      ),
    );
  }
}

inputname(musicname){
  if (musicname != ""){
    musics[0]['name'] = musicname;
  }else{
    musics[0]["name"] = "inferno";
  }
}