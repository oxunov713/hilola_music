import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../database/music_data.dart';
import '../model/music_model.dart';
import '../styles/app_icon.dart';

class ProviderMusic extends ChangeNotifier {
  late AudioPlayer _player;
  List<MusicModel> _musicDatabase = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  bool _isShuffle = false;
  late ConcatenatingAudioSource _playlist;

  final List<String> _images = [
    AppIcon.avatar,
    AppIcon.avatar1,
    AppIcon.avatar2,
    AppIcon.avatar3,
    AppIcon.avatar4,
    AppIcon.avatar5,
    AppIcon.avatar6,
    AppIcon.avatar7,
    AppIcon.avatar8,
    AppIcon.avatar9,
    AppIcon.avatar10,
  ];

  AudioPlayer get player => _player;

  ProviderMusic() {
    _player = AudioPlayer();
    _loadMusicDatabase();
    _initializePlayer();
  }

  void _loadMusicDatabase() {
    try {
      _musicDatabase = $data.map((json) => MusicModel.fromJson(json)).toList();
      _playlist = ConcatenatingAudioSource(
        children: _musicDatabase
            .map((music) => AudioSource.uri(
                  Uri.parse("asset:///assets/${music.path}"),
                ))
            .toList(),
      );
    } catch (e) {
      print('Error loading music database: $e');
    }
  }

  void _initializePlayer() async {
    try {
      await _player.setAudioSource(_playlist);

      _player.currentIndexStream.listen((index) {
        _currentIndex = index ?? 0;
        notifyListeners();
      });

      _player.positionStream.listen((position) {
        _currentPosition = position;
        notifyListeners();
      });

      _player.playerStateStream.listen((playerState) {
        _isPlaying = playerState.playing;
        notifyListeners();
      });

      preloadDurations();
    } catch (e) {
      print('Error initializing player: $e');
    }
  }

  Future<void> preloadDurations() async {
    try {
      for (int i = 0; i < _musicDatabase.length; i++) {
        final music = _musicDatabase[i];
        final player = AudioPlayer();
        try {
          await player.setAudioSource(AudioSource.uri(
            Uri.parse("asset:///assets/${music.path}"),
          ));
          var duration = player.duration;
          music.duration = duration ?? Duration.zero;
          music.imagePath = _images[i % _images.length];
        } catch (e) {
          print('Error preloading duration for ${music.name}: $e');
        } finally {
          player.dispose();
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error in preloadDurations: $e');
    }
  }

  List<MusicModel> get musicDatabase => _musicDatabase;

  int get currentIndex => _currentIndex;

  bool get isPlaying => _isPlaying;

  Duration get currentPosition => _currentPosition;

  bool get isShuffle => _isShuffle;

  MusicModel? get currentMusic =>
      _musicDatabase.isNotEmpty ? _musicDatabase[currentIndex] : null;

  String? get currentMusicName => currentMusic?.name;

  String? get currentMusicImagePath => currentMusic?.imagePath;

  Duration? get currentMusicDuration => currentMusic?.duration;

  String? getMusicName(int index) {
    return _musicDatabase[index].name;
  }

  Duration getDuration(int index) {
    return _musicDatabase[index].duration ?? Duration.zero;
  }

  Future<void> playMusic(int index) async {
    try {
      if (_currentIndex == index) {
        if (_isPlaying) {
          await _player.pause();
        } else {
          await _player.play();
        }
      } else {
        _currentIndex = index;
        await _player.seek(Duration.zero, index: _currentIndex);
        await _player.play();
      }
    } catch (e) {
      print('Error playing music at index $index: $e');
    }
  }

  void pausePlay() async {
    try {
      if (_isPlaying) {
        await _player.pause();
      } else {
        await _player.play();
      }
    } catch (e) {
      print('Error toggling play/pause: $e');
    }
  }

  Future<void> playNext() async {
    try {
      await _player.seekToNext();
      notifyListeners();
    } catch (e) {
      print('Error playing next music: $e');
    }
  }

  Future<void> playPrevious() async {
    try {
      await _player.seekToPrevious();
      notifyListeners();
    } catch (e) {
      print('Error playing previous music: $e');
    }
  }

  void toggleShuffle() async {
    try {
      _isShuffle = !_isShuffle;
      await _player.setShuffleModeEnabled(_isShuffle);
      notifyListeners();
    } catch (e) {
      print('Error toggling shuffle mode: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
