var genre = "J-POP";
var artist = "ミセス";
double sensingBPM = 150.0;
double previous_sensingBPM = 165.0;
var playlist = [0,0,0,0,0];
var music = "audio/Mrs. GREEN APPLE_青と夏__BPM185.mp3";

double bpm_ratio = 1.0;
int ORIGINAL_musicBPM = 138; //goodnight:138, bgm1:152
bool _changeAudioSource = true;
String _stateSource = 'アセットを再生';
int oldtime = 0;
int newtime = 0;
List<int> duls = [1, 1, 1, 1, 1]; //過去5回分のステップ間隔