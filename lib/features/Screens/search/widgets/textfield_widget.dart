import 'package:flutter/material.dart';
import 'package:music_application_1/features/provider/search_provider.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.searchController,
    required this.searchPro,
  });

  final TextEditingController searchController;
  final SearchProvider searchPro;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      onChanged: (value) {
        searchPro.searchsong(value);
      },
      decoration: InputDecoration(
        hintText: 'Find your music',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            searchController.clear();
            searchPro.searchsong('');
          },
        ),
      ),
    );
  }
}
