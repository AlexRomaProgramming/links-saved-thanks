import 'dart:async';

import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/models/link_info_model.dart';
import 'package:links_saved_thanks/widgets/background.dart';
import 'package:links_saved_thanks/widgets/bottom_bar.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final StorageController storageController = Get.find();
  final TextEditingController _searchQuery = new TextEditingController();
  late List<LinkInfoModel> suggestionsList;
  Timer? _debounce;
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, //for avoid resizing of layout with keyboard
      bottomNavigationBar: BottomBar(storageController: storageController),
      body: Stack(children: [
        const BackgroundWidget(),
        FadeInRight(
          delay: Duration(milliseconds: 500),
          duration: Duration(milliseconds: 500),
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [_searchTextInput(), _listHistoryOrSuggestions()],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchQuery.dispose();
    super.dispose();
  }

  TextField _searchTextInput() {
    return TextField(
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22),
      controller: _searchQuery,
      onChanged: _onSearchChanged,
      cursorColor: Colors.white,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.indigo.shade900,
          prefixIcon: Icon(
            FontAwesomeIcons.search,
            color: Colors.white38,
          ),
          suffixIcon: query.length == 0
              ? null
              : GestureDetector(
                  child: Icon(FontAwesomeIcons.times, color: Colors.white),
                  onTap: () {
                    setState(() {
                      _searchQuery.clear();
                      query = '';
                    });
                  },
                ),
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.white38, fontSize: 22),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30))),
    );
  }

  Widget _listHistoryOrSuggestions() {
    if (query.length < 2) {
      return Expanded(child: Container(child: _historyList()));
    } else {
      return Expanded(child: Container(child: _suggestionsList()));
    }
  }

  void _onSearchChanged(String searchText) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      setState(() {
        query = searchText;
      });
    });
  }

  Widget _historyList() {
    final historyList = storageController.searchHistoryList;
    suggestionsList = [];
    historyList.forEach((historyElement) {
      storageController.allLinks.forEach((element) {
        if (element.title == historyElement) suggestionsList.add(element);
      });
    });
    return FadeIn(
      duration: Duration(milliseconds: 500),
      child: ListView.builder(
        itemCount: suggestionsList.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Container(
                width: Get.width * 0.2,
                height: double.infinity,
                child: suggestionsList[index].image == 'no_image'
                    ? Image.asset('assets/img/no-image.png',
                        width: double.infinity, fit: BoxFit.cover)
                    : FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: 'assets/img/jar-loading.gif',
                        image: suggestionsList[index].image)),
            title: Text(
              suggestionsList[index].title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            subtitle: Text(suggestionsList[index].folder.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white70, fontSize: 14)),
            onTap: () {
              _saveToHistory(index);
              Get.offNamed('folder', arguments: [
                suggestionsList[index].folder[0],
                suggestionsList[index].title
              ]);
            },
          );
        },
      ),
    );
  }

  Widget _suggestionsList() {
    suggestionsList = [];
    storageController.allLinks.forEach((element) {
      if (element.title.toLowerCase().contains(query.toLowerCase())) {
        suggestionsList.add(element);
      }
    });

    if (suggestionsList.length > 0) {
      return FadeIn(
        duration: Duration(milliseconds: 500),
        child: ListView.builder(
          itemCount: suggestionsList.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Container(
                  width: Get.width * 0.2,
                  height: double.infinity,
                  child: suggestionsList[index].image == 'no_image'
                      ? Image.asset('assets/img/no-image.png',
                          width: double.infinity, fit: BoxFit.cover)
                      : FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: 'assets/img/jar-loading.gif',
                          image: suggestionsList[index].image)),
              title: Text(
                suggestionsList[index].title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              subtitle: Text(suggestionsList[index].folder.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              onTap: () {
                _saveToHistory(index);

                Get.offNamed('folder', arguments: [
                  suggestionsList[index].folder[0],
                  suggestionsList[index].title
                ]);
              },
            );
          },
        ),
      );
    } else {
      return Center(
          child: Icon(
        FontAwesomeIcons.question,
        size: 200,
        color: Colors.white.withOpacity(0.3),
      ));
    }
  }

  void _saveToHistory(int index) {
    //avoid repeated links in history
    if (storageController.searchHistoryList
        .contains(suggestionsList[index].title)) {
      storageController.searchHistoryList.remove(suggestionsList[index].title);
    }
    //add link to history in 0 position
    storageController.searchHistoryList.insert(0, suggestionsList[index].title);
    //control length of the history list
    if (storageController.searchHistoryList.length > 20) {
      storageController.searchHistoryList.removeLast();
    }
  }
}
