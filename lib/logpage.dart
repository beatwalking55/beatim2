import 'package:beatim/variables.dart';
import 'package:flutter/material.dart';
import 'log.dart';
import 'musicdata.dart';

class logpage extends StatefulWidget {
  const logpage({Key? key}) : super(key: key);

  @override
  State<logpage> createState() => _logpageState();
}

class _logpageState extends State<logpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('再生した曲一覧')
      ),
      body: Column(
        children: [
          Center(child: Text("星をタップして評価")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            for (var i = 0; i < 5; i++)
              IconButton(
                  onPressed:(){
                    setState(() {
                      log[log.length] = {
                        'month':DateTime.now().month,
                        'day':DateTime.now().day,
                        'song':musics[playingmusic]['name'],
                        'saiseisitaBPM':sensingBPM,
                        'evaluation': i + 1,
                      };
                    });
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.star_border)
              ),
            ],
          ),
          Flexible(
            child: ListView.builder(
              itemCount: log.length,
              itemBuilder: (BuildContext context, int index){
                if(log == null){
                  return Text("まだ評価はありません");
                }else {
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                                "${log[index]['month']}/ ${log[index]['day']}　"),
                            Text(log[index]['song']),
                          ],
                        ),

                        Row(
                          children: [
                            Text("                走ったBPM${log[index]['saiseisitaBPM'].toString()}　"),
                            Text("評価${log[index]['evaluation'].toString()}"),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
