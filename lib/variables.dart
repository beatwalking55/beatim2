import 'package:just_audio/just_audio.dart';
import 'musicdata.dart';

var genre = "J-POP"; //ジャンル
var artist = "ミセス"; //アーティスト
double sensingBPM = 165; //計測したBPM。再生速度はこれに合わせる。
var playlist = [0, 0, 0, 0, 0]; //プレイリスト。ここには曲のIDが入る。playpageではこの順に曲が表示・再生される。
var music = "audio/Mrs. GREEN APPLE_青と夏__BPM185.mp3"; //再生する曲のファイル名。
var visible =
    false; //「評価ページへ」ボタンと「再生中の曲を表示するやつ」が表示されるかどうか。一曲目がされるまでfalseにするのが望ましい。
String link = "";
String musicname = "";
int numberofmusics = 0;
int? previousIndex = -1;

double bpmRatio = 1.0; //BPM比であり曲の再生速度
double originalMusicBPM = 138; //goodnight:138, bgm1:152
int oldtime = 0;
int newtime = 0;
List<int> duls = [1, 1, 1, 1, 1, 1, 1];

ConcatenatingAudioSource newplaylist = ConcatenatingAudioSource(
  children: List.generate(
      playlist.length,
      (inde) => AudioSource.uri(
          Uri.parse('asset:${musics[playlist[inde]]['filename']}'))),
);
