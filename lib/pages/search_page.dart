import 'dart:async';

import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/helpers/functions.dart';
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
      bottomNavigationBar: BottomBar(),
      body: Stack(children: [
        const BackgroundWidget(),
        Get.width <= 600
            ? _searchInputField()
            : Container(
                child: _searchInputField(),
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.15))
      ]),
    );
  }

  Widget _searchInputField() {
    return FadeInRight(
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
          hintText: 'Search...'.tr,
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
          return _searchListItem(index);
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
            return _searchListItem(index);
            //  ListTile(
          },
        ),
      );
    } else {
      return Center(
          child: FadeIn(
        duration: Duration(milliseconds: 500),
        child: Icon(
          FontAwesomeIcons.question,
          size: 200,
          color: Colors.white.withOpacity(0.3),
        ),
      ));
    }
  }

  Widget _searchListItem(int index) {
    return GestureDetector(
      onTap: () {
        _saveToHistory(index);
        Get.offNamed('/folder', arguments: [
          suggestionsList[index].folder[0],
          suggestionsList[index].title
        ]);
        storageController.bottomBarIndex.value = 0;
      },
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? Get.height * 0.1
            : Get.height * 0.135,
        child: Row(
          children: [
            Container(
                width: Get.width > 600 ? 150 : Get.width * 0.26,
                height: double.infinity,
                child: imageToShow(
                    suggestionsList[index].image, storageController)),
            SizedBox(width: 5),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestionsList[index].title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(suggestionsList[index].folder.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color(0xFFfff59d), fontSize: 14))
                ],
              ),
            )
          ],
        ),
      ),
    );
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
