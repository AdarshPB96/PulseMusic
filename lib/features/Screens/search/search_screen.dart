import 'package:flutter/material.dart';
import 'package:music_application_1/core/colors/colors.dart';
import 'package:music_application_1/core/constants/constant_widgets.dart';
import 'package:music_application_1/features/Screens/home/widgets/songlist_widget.dart';
import 'package:music_application_1/features/Screens/miniplayer/miniplayer.dart';
import 'package:music_application_1/features/Screens/search/widgets/textfield_widget.dart';
import 'package:music_application_1/features/provider/search_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
 final TextEditingController searchController = TextEditingController();
  SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final searchPro = Provider.of<SearchProvider>(context, listen: false);
    return Scaffold(
      appBar: appBarWidget(text: "Search"),
      body: Container(
        decoration: containerColor(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: SearchTextField(searchController: searchController, searchPro: searchPro),
            ),
            Expanded(child: Consumer<SearchProvider>(
              builder: (context, value, child) {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return SongsList(
                          song: value.searchlist[index],
                          songlist: value.searchlist,
                          index: index);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 5,
                      );
                    },
                    itemCount: value.searchlist.length);
              },
            ))
          ],
        ),
      ),
      bottomSheet: const MiniPlayer(),
    );
  }
}

