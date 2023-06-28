// ignore: file_names
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:music_application_1/Screens/created_playlistsongs_screen.dart';
import 'package:music_application_1/function/dbfunctions.dart';
import 'package:music_application_1/models/playlistmodel.dart';

class PlaylistScreen extends StatelessWidget {
   PlaylistScreen({Key? key}) : super(key: key);


  final List<Image> imageslist = <Image>[
    Image.asset('assets/images/playlistimage3.jpg'),
    Image.asset('assets/images/playlistimage4.png'),
    Image.asset('assets/images/playlistimage5.jpg'),
    Image.asset('assets/images/playlistimage6.jpg'),
    Image.asset('assets/images/mask-boy-listening-music-neon-4k-gm.jpg'),
    Image.asset('assets/images/photo-Playlist.jpeg'),
    Image.asset('assets/images/playlistimage1.jpg'),
    Image.asset('assets/images/playlistimage2.jpeg'),
  ];
  final playbox = PlaylistSongsBox.getInstance();

  @override
  Widget build(BuildContext context) {
    final rhight = MediaQuery.of(context).size.height;
    final rwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Playlist'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black38, Color(0xFF880E4F)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ValueListenableBuilder(
                      valueListenable: playbox.listenable(),
                      builder: (context, value, child) {
                        List<PlaylistSongs> playlistitems =
                            playlistDb.values.toList();

                        return playlistitems.isNotEmpty
                            ? GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CreatedPlaylistSongs(
                                              // songindex: index,
                                              playlistname: playlistitems[index]
                                                  .playlistName,
                                            ),
                                          ));
                                      //
                                    },
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                              "Do you want to delete/edit playlist '${playlistitems[index].playlistName}'"),
                                          actions: [
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  deleteplaylist(
                                                      playlistitems[index]
                                                          .playlistName,
                                                      context);
                                                },
                                                icon: const Icon(Icons.delete)),
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  editPlaylist(
                                                      playlistitems[index]
                                                          .playlistName
                                                          .toString(),
                                                      context);
                                                },
                                                icon: const Icon(Icons.edit)),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      // color: Colors.white,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      child: Column(children: [
                                        ClipRRect(
                                          // borderRadius: BorderRadius.circular(10),
                                          child: Image(
                                            image: imageslist[
                                                    index % imageslist.length]
                                                .image,
                                            fit: BoxFit.cover,
                                            height: rhight * 0.15,
                                            width: rwidth * 0.45,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          playlistitems[index]
                                              .playlistName
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '${playlistitems[index].playlistsSongs?.length} Songs',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ]),
                                    ),
                                  );
                                },
                                itemCount: playlistitems.length,
                              )
                            : const Center(
                                child: Text(
                                  'No playlist to show',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return createPlaylistTextfield(context);
            },
          );
        },
        child: const Icon(Icons.playlist_add),
      ),
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
            style: const TextStyle(
              fontSize: 20,
            ),
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
