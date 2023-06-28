import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'now_playing_screen.dart';
import 'package:music_application_1/Screens/home.dart';
import 'package:music_application_1/Screens/miniplayer.dart';
import 'package:music_application_1/function/add_to_favourites.dart';
import 'package:music_application_1/function/dbfunctions.dart';
import 'package:music_application_1/models/playlistmodel.dart';
import 'package:music_application_1/models/recentplayed.dart';
import 'package:music_application_1/widget/playerfunction.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class Recentlyplayedscreen extends StatelessWidget {
  
   Recentlyplayedscreen({super.key}){
     Rplayedlist = box.values.toList().reversed.toList();
   }


  // ignore: non_constant_identifier_names
  List<RecentlyPlayed> Rplayedlist = [];
  final box = RecentplayedBox.getinstance();

  // @override
  // void initState() {
   
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => ,)
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Recently Played'),
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
            child:  Rplayedlist.isNotEmpty
                      ? ListView.separated(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          itemBuilder: (context, index) => RecentlyPlayedlist(
                              song: Rplayedlist[index % Rplayedlist.length],
                              songlist: Rplayedlist,
                              index: index),
                          itemCount: Rplayedlist.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            "Your Recent played songs will appear here!",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
               
          ),
        ]),
      ),
      bottomSheet: const MiniPlayer(),
    );
  }
}

class RecentlyPlayedlist extends StatefulWidget {
  final RecentlyPlayed song;
  List<RecentlyPlayed> songlist;
  final int index;
  RecentlyPlayedlist(
      {required this.song,
      required this.songlist,
      required this.index,
      super.key});

  @override
  State<RecentlyPlayedlist> createState() => _RecentlyPlayedlistState();
}

class _RecentlyPlayedlistState extends State<RecentlyPlayedlist> {
  final playbox = PlaylistSongsBox.getInstance();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        audioPlayer.stop();
        audioList.clear();
        for (RecentlyPlayed item in widget.songlist) {
          audioList.add(Audio.file(item.songurl!,
              metas: Metas(
                title: item.songname,
                artist: item.artist,
                id: item.id.toString(),
              )));
        }
        playingaudio(context, widget.index);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: QueryArtworkWidget(
        id: widget.song.id!,
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
          widget.song.songname!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      subtitle: Marquee(
        child: Text(widget.song.artist.toString(),
            style: const TextStyle(color: Colors.white)),
      ),
      trailing: PopupMenuButton(
        color: Colors.white,
        itemBuilder: (context) => [
          PopupMenuItem(
              child: TextButton(
            onPressed: () {
              addfav(widget.song.id, context);
              Navigator.of(context).pop();
            },
            child: Text(isalready(widget.song.id)
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
                    playlistDialogue(context, widget.index),
              );
            },
            child: const Text('Add to Playlist'),
          )),
        ],
      ),
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
                          widget.song.id!,
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
