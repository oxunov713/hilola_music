import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hilola_gayratova/widgets/player/player.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../../../../styles/app_color.dart';
import '../../styles/app_icon.dart';
import 'package:hilola_gayratova/provider/music_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late ProviderMusic _providerMusicRead;
  late ProviderMusic _providerMusicWatch;

  @override
  void didChangeDependencies() {
    _providerMusicRead = context.read<ProviderMusic>();
    _providerMusicWatch = context.watch<ProviderMusic>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.background,
          ),
          child: Column(
            children: [
              // AppBar
              const Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hilola G'ayratova",
                      style: TextStyle(
                        color: AppColors.appBarText,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              // ListTile
              Expanded(
                child: ListView.builder(
                  itemCount: _providerMusicWatch?.musicDatabase.length ?? 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: InkWell(
                        onTap: () => _providerMusicRead?.listTileMusic(index),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.cards,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              width: 2.5,
                              color: AppColors.border,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shade,
                                offset: Offset(5, 5),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          content: const SizedBox(
                                            height: 250,
                                            width: 250,
                                            child: Image(
                                              fit: BoxFit.cover,
                                              image: AppIcon.avatar,
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AppIcon.avatar,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    _providerMusicRead?.getMusicName(index) ??
                                        "Hilola?",
                                    style: const TextStyle(color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: _providerMusicWatch!.currentMusicName !=
                                            null &&
                                        (_providerMusicWatch!
                                                .musicDatabase[
                                                    _providerMusicWatch!.n]
                                                .id ==
                                            _providerMusicWatch!
                                                .musicDatabase[index].id)
                                    ? Lottie.asset(
                                        "assets/icons/lottie_music.json",
                                        height: 25,
                                        width: 25,
                                      )
                                    : Text(
                                        _providerMusicRead
                                                ?.getDuration(index)
                                                .toString()
                                                .substring(2, 7) ??
                                            '00:00',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Bottom Player
              _providerMusicWatch?.currentMusicName != null
                  ? InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Player()),
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 15),
                              child: Text(
                                "${_providerMusicWatch?.currentMusicName}",
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontFamily: "Exo",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: StreamBuilder<Duration>(
                              stream:
                                  _providerMusicWatch?.player.onPositionChanged,
                              builder: (context, snapshot) {
                                return ProgressBar(
                                  barHeight: 5,
                                  barCapShape: BarCapShape.round,
                                  timeLabelPadding: 7,
                                  baseBarColor: AppColors.progressbarback,
                                  progressBarColor: AppColors.appBarText,
                                  thumbColor: AppColors.appBarText,
                                  thumbRadius: 10,
                                  thumbGlowRadius: 0,
                                  progress: snapshot.data ?? Duration.zero,
                                  total: _providerMusicWatch?.maxDuration ??
                                      Duration.zero,
                                  onSeek: (duration) {
                                    _providerMusicWatch?.player.seek(duration);
                                  },
                                );
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {},
                                splashColor: Colors.transparent,
                                child: SvgPicture.asset(
                                  "assets/icons/back.svg",
                                  height: 30,
                                ),
                              ),
                              _providerMusicWatch!.isPlaying
                                  ? IconButton(
                                      icon: const Icon(
                                        CupertinoIcons.pause,
                                        size: 40,
                                        color: AppColors.shade,
                                      ),
                                      onPressed: () {
                                        _providerMusicRead?.player.pause();
                                        _providerMusicRead?.pausePlay();
                                      },
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        CupertinoIcons.play,
                                        size: 40,
                                        color: AppColors.shade,
                                      ),
                                      onPressed: () {
                                        _providerMusicRead?.player.resume();
                                        _providerMusicRead?.pausePlay();
                                      },
                                    ),
                              InkWell(
                                onTap: () {},
                                splashColor: Colors.transparent,
                                child: SvgPicture.asset(
                                  "assets/icons/next.svg",
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
