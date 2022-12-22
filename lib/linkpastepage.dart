import 'package:beatim/namepastepage.dart';
import 'package:flutter/material.dart';
import 'variables.dart';
import 'musicdata.dart';


class LinkPastePage extends StatefulWidget {
  const LinkPastePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LinkPastePage> createState() => _LinkPastePageState();
}

class _LinkPastePageState extends State<LinkPastePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google drive のリンクを貼り付け",
          style: TextStyle(
              color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("1:聞きたい音楽のmp3ファイルをgoogle driveにアップロード\n2:共有設定からリンクを知っている全員に編集者権限を付与\n3:共有リンクをコピーして貼り付けてください。",
                style: TextStyle(
                    color: Colors.black
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "リンク"
                  ),
                  onChanged: (text){
                    link = text;
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
                    ),
                  ),
                  onPressed:(){
                    setState(() {
                      inputlink(link);
                    });
                    if(numberofmusics > 0){
                      Navigator.push(context, MaterialPageRoute(builder:(context) => inputnamepage()));
                    }
                },
                    child: Text("次へ",style: TextStyle(fontSize: 30,color: Colors.black),)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

inputlink(link){
  int i = 0;
  List<String> links = link.split("/file");
  links.removeAt(0);
  numberofmusics = links.length;
  for(i=0; i<numberofmusics;i++){
      musics[i]['filename']="https://drive.google.com/uc?export=download&id=${links[i].substring(links[i].indexOf("d/")+2,links[i].indexOf("/view"))}";
      print(musics[i]['filename']);
  }
}