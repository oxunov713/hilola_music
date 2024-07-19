import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/music_data.dart';
import '../model/music_model.dart';
import '../styles/app_icon.dart';

class ProviderMusic extends ChangeNotifier {
  late AudioPlayer _player;
  List<MusicModel> _musicDatabase = [];
  int _currentIndex = -1;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  bool _isShuffle = false;
  late ConcatenatingAudioSource _playlist;
  bool isLoaded = false;

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

  List<MusicModel> get musicDatabase => _musicDatabase;

  int get currentIndex => _currentIndex;

  bool get isPlaying => _isPlaying;

  Duration get currentPosition => _currentPosition;

  bool get isShuffle => _isShuffle;

  MusicModel? get currentMusic =>
      _musicDatabase.isNotEmpty && _currentIndex >= 0
          ? _musicDatabase[_currentIndex]
          : null;

  String? get currentMusicName => currentMusic?.name;

  String? get currentMusicImagePath => currentMusic?.imagePath;

  Duration? get currentMusicDuration => currentMusic?.duration;

  ProviderMusic() {
    _player = AudioPlayer();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadMusicDatabase();
    await _initializePlayer();
    await _loadPreferences();
    await getDataIsLoaded();
  }

  Future<void> _loadMusicDatabase() async {
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

  Future<void> _initializePlayer() async {
    try {
      await _player.setAudioSource(_playlist);
      _player.currentIndexStream.listen((index) {
        _currentIndex = index ?? -1;
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
      await preloadDurations();
    } catch (e) {
      print('Error initializing player: $e');
    }
  }

  Future<void> preloadDurations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
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
          await _saveMusicDetails(music);
        } catch (e) {
          print('Error preloading duration for ${music.name}: $e');
        } finally {
          player.dispose();
        }
      }

      _currentIndex = prefs.getInt('currentIndex') ?? -1;
      _currentPosition =
          Duration(milliseconds: prefs.getInt('currentPosition') ?? 0);

      if (_currentIndex >= 0 && _currentIndex < _musicDatabase.length) {
        await _player.seek(_currentPosition, index: _currentIndex);
      }

      notifyListeners();
    } catch (e) {
      print('Error in preloadDurations: $e');
    }
  }

  Future<void> _saveMusicDetails(MusicModel music) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          '${music.name}_duration', music.duration!.inMilliseconds);
      await prefs.setString('${music.name}_imagePath', music.imagePath!);
    } catch (e) {
      print('Error saving music details for ${music.name}: $e');
    }
  }

  String? getMusicName(int index) {
    if (index < 0 || index >= _musicDatabase.length) {
      return null; // Index out of bounds
    }
    return _musicDatabase[index].name;
  }

  Duration getDuration(int index) {
    if (index < 0 || index >= _musicDatabase.length) {
      return Duration.zero; // Index out of bounds
    }
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
      await _savePreferences();
    } catch (e) {
      print('Error playing music at index $index: $e');
    }
  }

  Future<void> pausePlay() async {
    try {
      if (_isPlaying) {
        await _player.pause();
      } else {
        await _player.play();
      }
      await _savePreferences();
    } catch (e) {
      print('Error toggling play/pause: $e');
    }
  }

  Future<void> playNext() async {
    try {
      await _player.seekToNext();
      await _savePreferences();
    } catch (e) {
      print('Error playing next music: $e');
    }
  }

  Future<void> playPrevious() async {
    try {
      await _player.seekToPrevious();
      await _savePreferences();
    } catch (e) {
      print('Error playing previous music: $e');
    }
  }

  Future<void> toggleShuffle() async {
    try {
      _isShuffle = !_isShuffle;
      await _player.setShuffleModeEnabled(_isShuffle);
      await _savePreferences();
    } catch (e) {
      print('Error toggling shuffle mode: $e');
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentIndex', _currentIndex);
      await prefs.setBool('isShuffle', _isShuffle);
      await prefs.setInt('currentPosition', _currentPosition.inMilliseconds);
    } catch (e) {
      print('Error saving preferences: $e');
    }
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentIndex = prefs.getInt('currentIndex') ?? -1;
      _isShuffle = prefs.getBool('isShuffle') ?? false;
      _currentPosition =
          Duration(milliseconds: prefs.getInt('currentPosition') ?? 0);

      if (_currentIndex >= 0 && _currentIndex < _musicDatabase.length) {
        await _player.seek(_currentPosition, index: _currentIndex);
        if (_isPlaying) {
          await _player.play();
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error loading preferences: $e');
    }
  }

  Future<void> saveDataIsLoaded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isLoaded = true;
      await prefs.setBool("isLoaded", isLoaded);
    } catch (e) {
      print('Error saving data isLoaded: $e');
    }
  }

  Future<void> getDataIsLoaded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isLoaded = prefs.getBool("isLoaded") ?? false;
    } catch (e) {
      print('Error getting data isLoaded: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
