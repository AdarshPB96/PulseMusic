import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_application_1/core/colors/colors.dart';
import 'package:music_application_1/core/constants/constant_size.dart';
import 'package:music_application_1/domain/function/dbfunctions.dart';
import 'package:music_application_1/domain/models/playlistmodel.dart';
import 'package:music_application_1/features/Screens/playlist/widgets/createplaylist_textfield.dart';
import 'package:music_application_1/features/Screens/playlist/widgets/playlist_gridview.dart';
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
          decoration: containerColor(),
          child: Column(
            children: [
            sizedBoxH15,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ValueListenableBuilder(
                      valueListenable: playbox.listenable(),
                      builder: (context, value, child) {
                        List<PlaylistSongs> playlistitems =
                            playlistDb.values.toList();

                        return playlistitems.isNotEmpty
                            ? playlistGridview(playlistitems, rhight, rwidth,imageslist)
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
}
