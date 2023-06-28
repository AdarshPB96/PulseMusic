import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'now_playing_screen.dart';
import 'package:music_application_1/Screens/home.dart';
import 'package:music_application_1/Screens/miniplayer.dart';
import 'package:music_application_1/function/add_to_favourites.dart';
import 'package:music_application_1/function/dbfunctions.dart';
import 'package:music_application_1/models/mostplayeddb.dart';
import 'package:music_application_1/models/playlistmodel.dart';
import 'package:music_application_1/widget/playerfunction.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MostlyPlayed extends StatelessWidget {
  MostlyPlayed({super.key});

  final box = MostPlayedBox.getInstance();
  final List<Audio> songs = [];
  final List<MostPlayed> mostfinalsongs = [];

  // @override
  // void initState() {
  //   List<MostPlayed> songlist = box.values.toList();
  //   int i = 0;
  //   for (MostPlayed items in songlist) {
  //     if (items.count > 3) {
  //       mostfinalsongs.insert(i, items);
  //       i++;
  //     }
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    initializeData();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text('Mostly Played'),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black38, Color(0xFF880E4F)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Column(children: [
            Expanded(
              child: ValueListenableBuilder<Box<MostPlayed>>(
                  valueListenable: box.listenable(),
                  builder: (context, value, child) {
                    return mostfinalsongs.isNotEmpty
                        ? ListView.separated(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            itemBuilder: (context, index) => MostPlayedList(
                                song: mostfinalsongs[index],
                                songlist: mostfinalsongs,
                                index: index),
                            itemCount: mostfinalsongs.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              "Your most played songs will appear here!`",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                  }),
            ),
          ]),
        ),
        bottomSheet: const MiniPlayer());
  }

  void initializeData() {
    List<MostPlayed> songlist = box.values.toList();
    int i = 0;
    for (MostPlayed items in songlist) {
      if (items.count > 3) {
        mostfinalsongs.insert(i, items);
        i++;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeData();
    });
  }
}

// ignore: must_be_immutable
class MostPlayedList extends StatelessWidget {
  final MostPlayed song;
  List<MostPlayed> songlist;
  final Color? color;
  final int index;

  MostPlayedList(
      {required this.song,
      required this.songlist,
      this.color,
      required this.index,
      super.key});


  final playbox = PlaylistSongsBox.getInstance();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: color ?? Colors.black,
      onTap: () {
        audioPlayer.stop();
        audioList.clear();
        for (MostPlayed item in songlist) {
          audioList.add(Audio.file(item.songurl!,
              metas: Metas(
                title: item.songname,
                artist: item.artist,
                id: item.id.toString(),
              )));
        }
        playingaudio(context, index);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: QueryArtworkWidget(
        id: song.id!,
        size: 3000,
        artworkFit: BoxFit.cover,
        type: ArtworkType.AUDIO,
        artworkBorder: BorderRadius.circular(10),
        artworkQuality: FilterQuality.high,
        nullArtworkWidget: const Image(
          width: 50,
          height: 50,
          image: AssetImage(
            'assets/images/pulse-music-low-resolution-color-logo.png',
          ),
        ),
      ),
      title: Marquee(
        child: Text(
          song.songname!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      subtitle: Marquee(
        child: Text(song.artist.toString(),
            style: const TextStyle(color: Colors.white)),
      ),
      trailing: PopupMenuButton(
        color: Colors.white,
        itemBuilder: (context) => [
          PopupMenuItem(
              child: TextButton(
            onPressed: () {
              addfav(song.id, context);
              Navigator.of(context).pop();
            },
            child: Text(isalready(song.id)
                ? 'Remove from favourites'
                : 'Add to favourites'),
          )),
          PopupMenuItem(
              child: TextButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    playlistDialogue(context, index),
              );
            },
            child: const Text('Add to Playlist'),
          )),
        ],
      ),
      // trailing: IconButton(
      //     onPressed: () {
      //       isfav = !isfav;
      //       setState(() {});

      //       addfav(widget.song.id);
      //     },
      //     icon: isfav
      //         ? const Icon(Icons.favorite, color: Colors.red)
      //         : const Icon(
      //             Icons.favorite_border,
      //             color: Colors.white,
      //           )),
    );
  }

  playlistDialogue(BuildContext context, int songindex) {
    return AlertDialog(
      title: const Text('Add to Playlist'),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) => createPlaylistTextfield(context),
              );
            },
            child: const Text('Create New Playlist'),
          ),
        ),
        Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: ValueListenableBuilder<Box<PlaylistSongs>>(
              valueListenable: playbox.listenable(),
              builder: (context, value, child) {
                List<PlaylistSongs> playlistitems = playlistDb.values.toList();
                return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        playlistitems[index].playlistName.toString(),
                        textAlign: TextAlign.center,
                      ),
                      tileColor: Colors.amber[100],
                      onTap: () {
                        Navigator.pop(context);
                        addtoPlaylist(
                          song.id!,
                          playlistitems[index].playlistName,
                          context,
                        );
                      },
                    );
                  },
                  itemCount: playlistitems.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }

  createPlaylistTextfield(BuildContext context) {
    TextEditingController playlistcontroller = TextEditingController();
    return AlertDialog(
      title: const Text('Create Playlist'),
      actions: [
        SizedBox(
          child: TextField(
            controller: playlistcontroller,
            decoration: const InputDecoration(
              hintText: 'Playlist Name',
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              String name = playlistcontroller.text;
              createplaylist(name, context);
              Navigator.of(context).pop();
            },
            child: const Text('Create'))
      ],
    );
  }
}
