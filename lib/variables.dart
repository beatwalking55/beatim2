var genre = "J-POP"; //ジャンル
var artist = "ミセス"; //アーティスト
double sensingBPM = 165; //計測したBPM。再生速度はこれに合わせる。
var playlist = [0]; //プレイリスト。ここには曲のIDが入る。playpageではこの順に曲が表示・再生される。
var visible =
    false; //「評価ページへ」ボタンと「再生中の曲を表示するやつ」が表示されるかどうか。一曲目がされるまでfalseにするのが望ましい。
String link = "";
String musicname = "";
int numberofmusics = 0;
int? previousIndex = -1;

int oldtime = 0;
int newtime = 0;
List<int> duls = [1, 1, 1, 1, 1, 1, 1];

