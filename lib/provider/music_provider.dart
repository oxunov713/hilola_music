import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../database/music_data.dart';
import '../model/music_model.dart';

class ProviderMusic extends ChangeNotifier {
  List<MusicModel> musicDatabase =
      $data.map((json) => MusicModel.fromJson(json)).toList();

  final player = AudioPlayer();

  MusicModel? currentMusic;
  String? currentMusicName;
  Duration? maxDuration;
  String? currentMusicDuration;
  bool isPlaying = false;
  int n = 0;

  String? getMusicName(int a) {
    String musicName = musicDatabase[a].name!;

    return musicName;
  }

  void listTileMusic(int index) {
    if (isPlaying && musicDatabase[index].id == musicDatabase[n].id) {
      player.pause();
      isPlaying = false;
    } else {
      player.play(AssetSource(musicDatabase[index].path!));
      isPlaying = true;
    }
    n = index;
    player.setSourceAsset(musicDatabase[n].path!);
    player.onDurationChanged.listen((Duration duration) {
      maxDuration = duration;
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
