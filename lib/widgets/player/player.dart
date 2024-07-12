import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hilola_gayratova/styles/app_color.dart';
import 'package:provider/provider.dart';

import '../../provider/music_provider.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
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
    return Scaffold(
      backgroundColor: Color(0xe670acd3),
      body: Column(
        children: [
          SizedBox(
            height: 500,
          ),
          Column(
            children: [
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
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
                  stream: _providerMusicWatch?.player.onPositionChanged,
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
                      total: _providerMusicWatch?.maxDuration ?? Duration.zero,
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
        ],
      ),
    );
  }
}
