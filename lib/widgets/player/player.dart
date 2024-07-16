import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/music_data.dart';
import '../../provider/music_provider.dart';
import '../../styles/app_color.dart';
import '../../styles/app_icon.dart';

class Player extends StatelessWidget {
  const Player({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.shade,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(AppIcon.matBack),
        ),
        actions: [
          PopupMenuButton(
            iconSize: 25,
            itemBuilder: (context) => <PopupMenuEntry>[],
          ),
        ],
      ),
      body: Consumer<ProviderMusic>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: ListView(
              children: [
                const SizedBox(height: 60),
                // Asset image
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: SizedBox(
                    height: 370,
                    child: Image(
                      image: AssetImage(
                        provider.currentMusicImagePath ?? AppIcon.avatar,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.currentMusicName ?? $name,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                overflow: TextOverflow.ellipsis,
                              ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      $name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.borderSinger,
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                StreamBuilder<Duration>(
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
                      total: provider.currentMusicDuration ?? Duration.zero,
                      onSeek: (duration) {
                        provider.player.seek(duration);
                      },
                    );
                  },
                ),

                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () => provider.toggleShuffle(),
                      icon: const Icon(AppIcon.matShuffle),
                      color: provider.isShuffle
                          ? AppColors.deepPurple
                          : AppColors.white1,
                    ),
                    IconButton(
                      onPressed: () => provider.playPrevious(),
                      icon: const Icon(
                        AppIcon.matPrevious,
                        size: 45,
                      ),
                    ),
                    FilledButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(AppColors.deepPurple)),
                      onPressed: () {
                        provider.pausePlay();
                      },
                      child: Icon(
                        provider.isPlaying ? AppIcon.matPause : AppIcon.matPlay,
                        color: AppColors.white1,
                        size: 45,
                      ),
                    ),
                    IconButton(
                      onPressed: () => provider.playNext(),
                      icon: const Icon(
                        AppIcon.matNext,
                        size: 45,
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
