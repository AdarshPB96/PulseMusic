import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:music_application_1/features/Screens/home/home.dart';
import 'package:music_application_1/features/Screens/nowplaying/now_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});
  @override
  Widget build(BuildContext context) {
    var rheight = MediaQuery.of(context).size.height;
    var rwidth = MediaQuery.of(context).size.width;

    return audioPlayer1.builderCurrent(builder: (context, playing) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  ScreenNowPlaying(),
              ));
        },
        child: Container(
          width: rwidth,
          height: rheight * 0.12,
          // color: Colors.pink[700],
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 197, 179, 185),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: QueryArtworkWidget(
                  artworkHeight: rheight * 0.05,
                  artworkWidth: rheight * 0.05,
                  artworkFit: BoxFit.fill,
                  artworkBorder: const BorderRadius.all(Radius.circular(10)),
                  id: int.parse(playing.audio.audio.metas.id!),
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Container(
                    height: rheight * 0.06,
                    width: rheight * 0.06,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              'assets/images/pulse-music-low-resolution-color-logo.png'),
                        )),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Marquee(
                      child: Text(
                        audioPlayer1.getCurrentAudioTitle,
                      ),
                    ),
                    Marquee(
                      child: Text(
                          audioPlayer1.getCurrentAudioArtist == "<unknown>"
                              ? 'Artist Not Found'
                              : audioPlayer1.getCurrentAudioArtist,
                          style:
                              const TextStyle(overflow: TextOverflow.ellipsis)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              PlayerBuilder.isPlaying(
                player: audioPlayer1,
                builder: (context, isPlaying) => Wrap(children: [
                  IconButton(
                      onPressed: () {
                        audioPlayer1.previous();
                      },
                      icon: const Icon(Icons.skip_previous)),
                  IconButton(
                      onPressed: () {
                        audioPlayer1.playOrPause();
                      },
                      icon: Icon((isPlaying) ? Icons.pause : Icons.play_arrow)),
                  IconButton(
                      onPressed: () {
                        audioPlayer1.next();
                      },
                      icon: const Icon(Icons.skip_next)),
                ]),
              )
            ],
          ),
        ),
      );
    });
  }
}
