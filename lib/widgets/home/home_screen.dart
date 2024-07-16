import 'package:flutter/material.dart';
import 'package:hilola_gayratova/database/music_data.dart';
import 'package:provider/provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../../styles/app_color.dart';
import '../../provider/music_provider.dart';
import '../../styles/app_icon.dart';
import '../player/player.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<ProviderMusic>(
          builder: (context, provider, _) {
            return DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.background,
              ),
              child: Column(
                children: [
                  // AppBar
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      $name,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.appBarText,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  // Music List
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.musicDatabase.length,
                      itemBuilder: (context, index) {
                        bool isCurrentPlaying = provider.currentIndex == index;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          child: InkWell(
                            onTap: () => provider.playMusic(index),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                        provider.musicDatabase[index]
                                                .imagePath ??
                                            AppIcon.avatar,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(
                                        provider.getMusicName(index) ??
                                            'Music Name',
                                        style: const TextStyle(
                                            color: AppColors.black),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: isCurrentPlaying
                                        ? Lottie.asset(
                                            AppIcon.lottieMusic,
                                            height: 25,
                                            width: 25,
                                          )
                                        : Text(
                                            provider
                                                .getDuration(index)
                                                .toString()
                                                .substring(2, 7),
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
                  if (provider.currentMusic != null)
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Player()),
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 15,
                              ),
                              child: Text(
                                provider.currentMusic!.name,
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
                              stream: provider.player.positionStream,
                              builder: (context, snapshot) {
                                final position = snapshot.data ?? Duration.zero;
                                return ProgressBar(
                                  barHeight: 5,
                                  barCapShape: BarCapShape.round,
                                  timeLabelPadding: 7,
                                  baseBarColor: AppColors.progressBarBack,
                                  progressBarColor: AppColors.appBarText,
                                  thumbColor: AppColors.appBarText,
                                  thumbRadius: 10,
                                  thumbGlowRadius: 0,
                                  progress: position,
                                  total: provider.currentMusic!.duration ??
                                      Duration.zero,
                                  onSeek: (duration) {
                                    provider.player.seek(duration);
                                  },
                                );
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () => provider.playPrevious(),
                                splashColor: Colors.transparent,
                                child: SvgPicture.asset(
                                  AppIcon.back,
                                  height: 30,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  provider.isPlaying
                                      ? AppIcon.cupPause
                                      : AppIcon.cupPlay,
                                  size: 40,
                                  color: AppColors.shade,
                                ),
                                onPressed: () {
                                  provider.pausePlay();
                                },
                              ),
                              InkWell(
                                onTap: () => provider.playNext(),
                                splashColor: Colors.transparent,
                                child: SvgPicture.asset(
                                  AppIcon.next,
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
