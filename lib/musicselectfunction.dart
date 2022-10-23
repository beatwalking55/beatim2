import 'package:beatim/variables.dart';
import 'musicdata.dart';
import 'variables.dart';

final _numList = List.generate(musics.length, (index) => index);

musicselect({genre, artist, BPM}){
  List<List> playList_a = [];
  List<List> playList_b = [];
  List<List> playList_c = [];
  List<int> playList = [];
  List<int> playList_a2 = [];
  List<int> playList_b2 = [];
  List<int> playList_c2 = [];
  for (int num in _numList){
    if (musics[num]['genre1']== genre && musics[num]['artist']== artist){
      playList_a.add([num, (BPM - musics[num]['BPM']).abs()]);
    } else if (musics[num]['genre1'] == genre && musics[num]['artist']!= artist){
      playList_b.add([num, (BPM - musics[num]['BPM']).abs()]);
    }else{
      playList_c.add([num, (BPM - musics[num]['BPM']).abs()]);
    }
  }
  playList_a.sort(
        (a, b) {
      return a[1].compareTo(b[1]);
    },
  );
  playList_b.sort(
        (a, b) {
      return a[1].compareTo(b[1]);
    },
  );
  playList_c.sort(
        (a, b) {
      return a[1].compareTo(b[1]);
    },
  );
  playList_a2 = List.generate(playList_a.length, (index) => playList_a[index][0]);
  playList_b2 = List.generate(playList_b.length, (index) => playList_b[index][0]);
  playList_c2 = List.generate(playList_c.length, (index) => playList_c[index][0]);
  playList.addAll(playList_a2);
  playList.addAll(playList_b2);
  playList.addAll(playList_c2);
  return playList;
}