import 'package:beatim/variables.dart';

musicselect({ artist, BPM}){
  if (artist == "ミセス"){
    if (BPM < 170){
      return [1,1,1,1,1];
    }else{
      return [0,2,2,2,2];
    }
  }else{
    return [3,4,5,6,7,8,9,10,11,12,13];
  }
}