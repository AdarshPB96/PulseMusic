import 'package:flutter/material.dart';
import 'package:music_application_1/core/colors/colors.dart';
import 'package:music_application_1/core/constants/constant_widgets.dart';
import 'package:music_application_1/domain/models/fav_model.dart';
import 'package:music_application_1/features/Screens/favourites/widgets/favourites_listview_item.dart';
import 'package:music_application_1/features/provider/fav_provider.dart';
import 'package:provider/provider.dart';
class FavouritesScreen extends StatelessWidget {
  FavouritesScreen({super.key});
  final box = Favouritesbox.getInstance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(text: 'Favourites'),
      body: Container(
        decoration: containerColor(),
        child: Column(children: [
          Consumer<Favprovider>(
            builder: (context, value, child) {
              final List<FavModel> favitemsongs = value.getFavItemSongs();
              return Expanded(
                  child: favitemsongs.isNotEmpty
                      ? ListView.separated(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          itemBuilder: (context, index) {
                            return Favouritelist(
                                song: favitemsongs[index],
                                songlist: favitemsongs,
                                index: index);
                          },
                          itemCount: favitemsongs.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            "You haven't liked any Songs",
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
            },
          ),
        ]),
      ),
    );
  }
}
