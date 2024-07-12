import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hilola_gayratova/provider/music_provider.dart';
import 'package:provider/provider.dart';

import '../../../../styles/app_color.dart';
import '../../database/music_data.dart';
import '../../model/music_model.dart';
import '../../styles/app_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  ProviderMusic? _providerMusicRead;
  ProviderMusic? _providerMusicWatch;

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
              //appbar
              const Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Hilola G'ayratova",
                            style: TextStyle(
                              color: AppColors.appBarText,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
              //listtile
              SizedBox(
                height: 580,
                width: double.infinity,
                child: ListView(
                  children: List.generate(
                    _providerMusicWatch?.musicDatabase.length ?? 1,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: InkWell(
                        onTap: () => (),
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.cards,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
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
                                padding: const EdgeInsets.only(
                                  left: 18,
                                  top: 3,
                                  bottom: 3,
                                ),
                                child: InkWell(
                                  onTap: () => showDialog(
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
                                  ),
                                  child: const CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AppIcon.avatar,
                                  ),
                                ),
                              ),
                              Text(
                                _providerMusicRead?.getMusicName(index) ??
                                    "Hilola?",
                                style: TextStyle(
                                    color: (_providerMusicWatch!
                                                .musicDatabase[
                                                    _providerMusicWatch!.n]
                                                .id ==
                                            _providerMusicWatch!
                                                .musicDatabase[index].id)
                                        ? Colors.green
                                        : Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Text(
                                  "${_providerMusicWatch?.currentMusicDuration}",
                                  style: TextStyle(
                                      color: (_providerMusicWatch!
                                                  .musicDatabase[
                                                      _providerMusicWatch!.n]
                                                  .id ==
                                              _providerMusicWatch!
                                                  .musicDatabase[index].id)
                                          ? Colors.green
                                          : Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //bottomplayer
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  child: Text(
                    "${_providerMusicWatch?.currentMusicName}",
                    style: const TextStyle(
                        fontSize: 23,
                        fontFamily: "Exo",
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: StreamBuilder(
                  stream: _providerMusicWatch?.player.onPositionChanged,
                  builder: (context, snapshot) => ProgressBar(
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
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () => (),
                    splashColor: Colors.transparent,
                    child: SvgPicture.asset(
                      "assets/icons/back.svg",
                      height: 30,
                    ),
                  ),
                  Center(
                    child: _providerMusicWatch!.isPlaying
                        ? IconButton.outlined(
                            icon: const Icon(
                              CupertinoIcons.pause,
                              size: 36,
                              color: AppColors.appBarbackground,
                            ),
                            onPressed: () => (),
                          )
                        : InkWell(
                      onTap: () => (),
                      splashColor: Colors.transparent,
                      child: SvgPicture.asset(
                        "assets/icons/pause.svg",
                        height: 30,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => (),
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
        ),
      ),
    );
  }
}
