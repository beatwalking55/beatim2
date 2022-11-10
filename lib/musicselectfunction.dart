import 'package:beatim/variables.dart';
import 'musicdata.dart';
import 'variables.dart';

musicselect({genre, artist, BPM}){
  int i = 0;

  List<List> playList_a = []; //genre,artist一致した曲IDとそのBPM差を収納する仮プレイリスト
  List<List> playList_b = []; //genre一致,artist不一致の曲IDとそのBPM差を収納
  List<List> playList_c = []; //genre,artist不一致の曲IDとそのBPM差を収納

  List<int> playList = []; //再生リストの曲IDのみを収納

  List<int> playList_a2 = [];//genre,artist一致した曲IDを収納する仮プレイリスト
  List<int> playList_b2 = [];//genre一致,artist不一致の曲IDを収納
  List<int> playList_c2 = [];//genre,artist不一致の曲IDを収納

  //まずgenre,artistに応じて曲を仮プレイリスト振り分ける。この時、後々BPM一致度順で並べ替えるので曲BPMとsensingBPMの差分も一緒に入れる
  //BPMが計測BPMの0.9~1.3の範囲の物を選別する。
  for (i = 0; i<musics.length; i++){
    if (musics[i]["BPM"] <= sensingBPM * 1.3 && musics[i]["BPM"] >= sensingBPM * 0.95 ){
      if ((musics[i]['genre1']== genre || musics[i]['genre2'].toString() == genre) && musics[i]['artist']== artist){
        playList_a.add([i, (BPM - musics[i]['BPM']).abs()]);
      } else if (musics[i]['genre1'] == genre || musics[i]['genre2'] ==genre){
        playList_b.add([i, (BPM - musics[i]['BPM']).abs()]);
      }else{
        playList_c.add([i, (BPM - musics[i]['BPM']).abs()]);
      }
    }
  }
  //次にかく仮プレイリストをBPM差順に並べ替える
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

  //仮プレイリストから曲IDのみを取ってきて仮プレイリストを作る
  playList_a2 = List.generate(playList_a.length, (index) => playList_a[index][0]);
  playList_b2 = List.generate(playList_b.length, (index) => playList_b[index][0]);
  playList_c2 = List.generate(playList_c.length, (index) => playList_c[index][0]);

  //playListにそれぞれの仮プレイリストを加えて結合
  playList.addAll(playList_a2);
  playList.addAll(playList_b2);
  playList.addAll(playList_c2);

  return playList;
}