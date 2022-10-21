import 'package:beatim/variables.dart';
import 'musicdata.dart';
import 'variables.dart';

final numList = List.generate(musics.length, (index) => index);

musicselect({genre, artist, BPM}){
  List<int> playList = [];
  for (int num in numList){
    if (musics[num]['genre1']== genre && musics[num]['artist']== artist){
      playList.add(num);
    }
  }
  return playList;
}