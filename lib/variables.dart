import 'package:flutter/material.dart';

var genre = "J-POP";
var artist = "ミセス";
double sensingBPM = 150;
double previous_sensingBPM = 165;
var playlist = [0,0,0,0,0];
var music = "audio/Mrs. GREEN APPLE_青と夏__BPM185.mp3";
var playericon = Icons.play_arrow;
int playingmusic = 0;
var visible = false;
var changingspeed = true;
var changingspeedbutton = "原曲";

double bpm_ratio = 1.0;
int ORIGINAL_musicBPM = 138; //goodnight:138, bgm1:152
bool _changeAudioSource = true;
String _stateSource = 'アセットを再生';
int oldtime = 0;
int newtime = 0;
List<int> duls = [1, 1, 1, 1, 1];