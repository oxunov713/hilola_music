import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../database/music_data.dart';
import '../model/music_model.dart';

class ProviderMusic extends ChangeNotifier {
  List<MusicModel> musicDatabase =
      $data.map((json) => MusicModel.fromJson(json)).toList();

  final player = AudioPlayer();
  final player2 = AudioPlayer();

  MusicModel? currentMusic;
  String? currentMusicName;
  Duration? maxDuration;
  String? currentMusicDuration;
  bool isPlaying = false;
  int n = 0;

  late Future<void> preloadingFuture;

  ProviderMusic() {
    preloadingFuture = _preloadDurations();
  }

  Future<void> _preloadDurations() async {
    for (var music in musicDatabase) {
      final player2 = AudioPlayer();
      await player2.setSource(AssetSource(music.path));
      var duration = await player2.getDuration();
      music.duration = duration ?? Duration.zero;
      player2.dispose();
    }
    notifyListeners();
  }

  String? getMusicName(int a) {
    return musicDatabase[a].name;
  }

  void listTileMusic(int index) async {
    _preloadDurations();
    if (isPlaying && musicDatabase[index].id == musicDatabase[n].id) {
      await player.pause();
      isPlaying = false;
    } else {
      await player.play(AssetSource(musicDatabase[index].path));
      isPlaying = true;
      n = index;

      maxDuration = await player.getDuration();
    }
    currentMusicName = musicDatabase[n].name;
    notifyListeners();
  }

  void pausePlay() {
    isPlaying = !isPlaying;
    notifyListeners();
  }

  Duration getDuration(int a) {
    return musicDatabase[a].duration ?? Duration.zero;
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
