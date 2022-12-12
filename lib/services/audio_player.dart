import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  final audioPlayer =AudioPlayer();


  Future audio1Play()async {
    audioPlayer.play(AssetSource("audio/Message_Tone.mp3"));
  }
  Future audio2Play()async {
    audioPlayer.play(AssetSource("audio/Iphone - Message Tone.mp3"));
  }
  Future audioPause()async {
    audioPlayer.pause();
  }
}