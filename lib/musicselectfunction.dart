import 'package:beatim/variables.dart';
import 'musicdata.dart';

musicselect({genre, artist, BPM}) {
  int i = 0;
  List<int> playList = []; //再生リストの曲IDのみを収納





  //おまかせ（ジャンルフリー、アーティストフリー）の場合
  if (genre == "free" && artist == "free") {
    List <List> playList_ = []; //beatabilityも収納する仮プレイリスト

    //BPMが計測BPMの0.9~1.3の範囲の物を選別する。
    for (i = 0; i < musics.length; i++) {
      if (musics[i]["BPM"] <= sensingBPM/0.95 && musics[i]["BPM"] >= sensingBPM/1.3) {
        playList_.add([i, -musics[i]['beatability']]);//beatabilityは昇順でソートするためマイナスをかけている
      }
    }

    //beatabilityに応じて並べ替え
    playList_.sort(
          (a, b) {
        return a[1].compareTo(b[1]);
      },
    );
    playList = List.generate(playList_.length, (index) => playList_[index][0]);

    //BPM的に合う曲がなかった時の救済
    if (playList.length == 0) {
      return List.generate(musics.length, (index) => index);
    }
    return playList;
  }





  //ジャンル選択ページからきた（ジャンル指定、アーティストフリー）の場合
  else if (genre != "free" && artist == "free") {
    List<List> playList_a = []; //genre一致の曲IDとそのbeatabilityを収納する仮プレイリスト
    List<List> playList_b = []; //genre不一致の曲IDとそのbeatabilityを収納
    List<int> playLista = []; //genre一致の曲IDを収納する仮プレイリスト
    List<int> playListb = []; //genre不一致の曲IDを収納する仮プレイリスト

    for (i = 0; i < musics.length; i++) {
      //BPMが計測BPMの0.9~1.3の範囲の物を選別する。
      if (musics[i]["BPM"] <= sensingBPM/0.95 && musics[i]["BPM"] >= sensingBPM/1.3) {
        //ジャンル一致のものとそうでないものに振り分ける
        if (musics[i]['genre1'] == genre ||
            musics[i]['genre2'].toString() == genre) {
          playList_a.add([i, -musics[i]['beatability']]);
        } else {
          playList_b.add([i, (BPM - musics[i]['BPM']).abs()]);
        }
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
    //仮プレイリストから曲IDのみを取ってきて仮プレイリストを作る
    playLista =
        List.generate(playList_a.length, (index) => playList_a[index][0]);
    playListb =
        List.generate(playList_b.length, (index) => playList_b[index][0]);

    //playListにそれぞれの仮プレイリストを加えて結合
    playList.addAll(playLista);
    playList.addAll(playListb);

    //BPM的に合う曲がなかった時の救済
    if (playList.length == 0) {
      return List.generate(musics.length, (index) => index);
    }

    return playList;






    //アーティスト選択ページから来た（ジャンルフリー、アーティスト指定あり）の場合
  } else if (genre == "free" && artist != "free") {
    List<List> playList_a = []; //artist一致の曲IDとそのbeatabilityを収納する仮プレイリスト
    List<List> playList_b = []; //artist不一致の曲IDとそのbeatabilityを収納
    List<int> playLista = []; //artist一致した曲IDを収納する仮プレイリスト
    List<int> playListb = []; //artist不一致の曲IDを収納する仮プレイリスト

    for (i = 0; i < musics.length; i++) {
      //BPMが計測BPMの0.9~1.3の範囲の物を選別する。
      if (musics[i]["BPM"] <= sensingBPM/0.95 && musics[i]["BPM"] >= sensingBPM/1.3) {
        //ジャンル一致のものとそうでないものに振り分ける
        if (musics[i]['artist'] == artist) {
          playList_a.add([i, -musics[i]['beatability']]);
        } else {
          playList_b.add([i, (BPM - musics[i]['BPM']).abs()]);
        }
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
    //仮プレイリストから曲IDのみを取ってきて仮プレイリストを作る
    playLista =
        List.generate(playList_a.length, (index) => playList_a[index][0]);
    playListb =
        List.generate(playList_b.length, (index) => playList_b[index][0]);

    //playListにそれぞれの仮プレイリストを加えて結合
    playList.addAll(playLista);
    playList.addAll(playListb);

    //BPM的に合う曲がなかった時の救済
    if (playList.length == 0) {
      return List.generate(musics.length, (index) => index);
    }

    return playList;
  };
}