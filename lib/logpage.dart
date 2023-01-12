import 'package:beatim/variables.dart';
import 'package:flutter/material.dart';
import 'log.dart';
import 'musicdata.dart';
import 'playpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogPage extends StatefulWidget {
  const LogPage({Key? key}) : super(key: key);
  @override
  State<LogPage> createState() => _LogPageState();
}
//
class _LogPageState extends State<LogPage> {
  var db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('再生した曲一覧')
      ),
      body: Column(
        children: [
          const Center(child: Text("星をタップして評価")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 5; i++)
              IconButton(
                  onPressed:(){
                    // Create a new user with a first and last name
                    var user = <String, dynamic>{
                      "month": DateTime.now().month,
                      "day": DateTime.now().day,
                      "song": musics[playlist[player.currentIndex ?? 0]]['name'],
                      "saiseisitaBPM": sensingBPM,
                      "evaluation":i+1,
                    };

// Add a new document with a generated ID
                    db.collection("users").add(user).then((DocumentReference doc) =>
                        debugPrint('DocumentSnapshot added with ID: ${doc.id}'));
                    setState(() {
                      log[log.length] = {
                        'month':DateTime.now().month,
                        'day':DateTime.now().day,
                        'song':musics[playlist[player.currentIndex ?? 0]]['name'],
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


//評価一覧。(ログとして今後使うかもしれない)
//           Flexible(
//             child: ListView.builder(
//               itemCount: log.length,
//               itemBuilder: (BuildContext context, int index){
//                 if(log == null){
//                   return Text("まだ評価はありません");
//                 }else {
//                   return Padding(
//                     padding: EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                                 "${log[index]['month']}/ ${log[index]['day']}　"),
//                             Text(log[index]['song']),
//                           ],
//                         ),
//
//                         Row(
//                           children: [
//                             Text("                走ったBPM${log[index]['saiseisitaBPM'].toString()}　"),
//                             Text("評価${log[index]['evaluation'].toString()}"),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),

        ],
      ),
    );
  }
}
