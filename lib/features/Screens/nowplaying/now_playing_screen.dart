import 'package:flutter/material.dart';
import 'package:music_application_1/domain/models/songmodel.dart';
import 'package:music_application_1/features/provider/button_change_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:provider/provider.dart';

AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");

class ScreenNowPlaying extends StatelessWidget {
  ScreenNowPlaying({super.key});

  final bool isRepeat = false;
  final box = SongBox.getInstance();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return audioPlayer.builderCurrent(builder: (context, playing) {
      return Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.red,
            body: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.black.withOpacity(1),
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(1),
                  ])),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.06, horizontal: width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 28,
                                color: Colors.white,
                              )),

                          // AddPlstFromNow(songIndex:allDbSongs.indexWhere((element) =>
                          //           element.id == int.parse(playing.audio.audio.metas.id!)))
                        ],
                      ),
                    ),
                    //const Spacer(),
                    Container(
                      height: height * 0.4,
                      width: width * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),       
                      ),
                      child: QueryArtworkWidget(
                        artworkFit: BoxFit.cover,
                        id: int.parse(playing.audio.audio.metas.id!),
                        type: ArtworkType.AUDIO,
                        artworkQuality: FilterQuality.high,
                        size: 2000,
                        quality: 100,
                        artworkBorder: BorderRadius.circular(20),
                        nullArtworkWidget: Container(
                          width: width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/pulse-music-low-resolution-color-logo.png')),
                          ),
                          //child: Icon(Icons.abc),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(height * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width * 0.75,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0.0),
                              title: Marquee(
                                  // animationDuration:
                                  //     const Duration(milliseconds: 5500),
                                  // directionMarguee:
                                  //     DirectionMarguee.oneDirection,
                                  // pauseDuration:
                                  //     const Duration(milliseconds: 1000),
                                  child: Text(
                                audioPlayer.getCurrentAudioTitle,
                                //allDbSongs[widget.index].songname!,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                              subtitle: Text(
                                audioPlayer.getCurrentAudioArtist == '<unknown>'
                                    ? 'Unknown Artist'
                                    : audioPlayer.getCurrentAudioArtist,
                                //allDbSongs[widget.index].artist!,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Consumer<Buttonchange>(
                                builder: (context, favPro, child) {
                                  return IconButton(
                                      onPressed: () {
                                        favPro.addfav(
                                            int.parse(
                                                playing.audio.audio.metas.id!),
                                            context);
                                        // setState(() {});
                                      },
                                      icon: favPro.icon(int.parse(
                                          playing.audio.audio.metas.id!)));
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.018,
                          ),
                          SizedBox(
                            width: width * 0.75,
                            child: PlayerBuilder.realtimePlayingInfos(
                              player: audioPlayer,
                              builder: (context, realtimePlayingInfos) {
                                final duration = realtimePlayingInfos
                                    .current!.audio.duration;
                                final position =
                                    realtimePlayingInfos.currentPosition;
                                return ProgressBar(
                                  progress: position,
                                  total: duration,
                                  progressBarColor: Colors.white,
                                  baseBarColor: Colors.white.withOpacity(0.5),
                                  thumbColor: Colors.red,
                                  barHeight: 3.0,
                                  thumbRadius: 7.0,
                                  timeLabelTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  onSeek: (duration) {
                                    audioPlayer.seek(duration);
                                  },
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    SizedBox(
                      width: width * 0.75,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Consumer<Buttonchange>(
                              builder: (context, value, child) {
                                return IconButton(
                                    iconSize: 30,
                                    onPressed: () {
                                      value.setIsRepeat(!value.isRepeat);
                                      // setState(() {
                                      //   isRepeat = !isRepeat;
                                      // });
                                      if (value.isRepeat) {
                                        audioPlayer
                                            .setLoopMode(LoopMode.single);
                                      } else {
                                        audioPlayer.setLoopMode(LoopMode.none);
                                      }
                                    },
                                    icon: value.repeatIcon());
                              },
                            ),
                            IconButton(
                              iconSize: 30,
                              onPressed: () {
                                // setState(() {});
                                audioPlayer.toggleShuffle();
                              },
                              icon: audioPlayer.isShuffling.value
                                  ? const Icon(
                                      Icons.shuffle_on_outlined,
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.shuffle,
                                      color: Colors.white,
                                    ),
                            ),
                          ]),
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      width: width * 0.85,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PlayerBuilder.isPlaying(
                              player: audioPlayer,
                              builder: (context, isPlaying) {
                                return IconButton(
                                  iconSize: 35,
                                  onPressed: playing.index == 0
                                      ? () {}
                                      : () async {
                                          await audioPlayer.previous();
                                          if (!isPlaying) {
                                            audioPlayer.pause();
                                            // setState(() {});
                                          }
                                        },
                                  icon: playing.index == 0
                                      ? Icon(
                                          Icons.skip_previous,
                                          color: Colors.white.withOpacity(0.4),
                                          size: 35,
                                        )
                                      : const Icon(
                                          Icons.skip_previous,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                );
                              }),
                          IconButton(
                            iconSize: 35,
                            onPressed: () async {
                              audioPlayer.seekBy(const Duration(seconds: -10));
                            },
                            icon: const Icon(Icons.replay_10,
                                color: Colors.white, size: 35),
                          ),
                          PlayerBuilder.isPlaying(
                              player: audioPlayer,
                              builder: (context, isPlaying) {
                                return IconButton(
                                  iconSize: 55,
                                  onPressed: () {
                                    audioPlayer.playOrPause();
                                  },
                                  icon: Icon(
                                    isPlaying
                                        ? Icons.pause_circle
                                        : Icons.play_circle,
                                    color: Colors.red,
                                    size: 55,
                                  ),
                                );
                              }),
                          IconButton(
                            iconSize: 35,
                            onPressed: () async {
                              audioPlayer.seekBy(const Duration(seconds: 10));
                            },
                            icon: const Icon(Icons.forward_10,
                                color: Colors.white, size: 35),
                          ),
                          PlayerBuilder.isPlaying(
                              player: audioPlayer,
                              builder: (context, isPlaying) {
                                return IconButton(
                                  iconSize: 35,
                                  onPressed: () {
                        
                                    audioPlayer.next();
                                  },
                         
                                  icon: const Icon(
                                    Icons.skip_next,
                                    color: Colors.white,
                                  ),
                                );
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}
