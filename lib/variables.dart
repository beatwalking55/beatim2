var genre = "J-POP"; //ジャンル
var artist = "ミセス"; //アーティスト
double sensingBPM = 165; //計測したBPM。再生速度はこれに合わせる。
double previous_sensingBPM = 165; //前回再生したBPM。BPM選択ページで使う。
var playlist = [0,0,0,0,0]; //プレイリスト。ここには曲のIDが入る。playpageではこの順に曲が表示・再生される。
List<int> formar_playlist = [0,0,0,0,0];//再計測する前のプレイリストを一時保存する
var music = "audio/Mrs. GREEN APPLE_青と夏__BPM185.mp3"; //再生する曲のファイル名。
var visible = false; //「評価ページへ」ボタンと「再生中の曲を表示するやつ」が表示されるかどうか。一曲目がされるまでfalseにするのが望ましい。
var changingspeed = true; //曲の再生速度を変えているかどうか。「原曲」「走速」の表示切り替えに使う。
var changingspeedbutton = "原曲"; //「再生中の曲を表示するやつ」の原曲走速を切り替えるボタンに表示される文字。
//String comefrom = "bpmselectpage"; //BPMsensingpage　に遷移した際BPMselectpageとplaypageどちらからきたのかを示す。

double bpm_ratio = 1.0; //BPM比であり曲の再生速度
double ORIGINAL_musicBPM = 138; //goodnight:138, bgm1:152
int oldtime = 0;
int newtime = 0;
List<int> duls = [1, 1, 1, 1, 1];