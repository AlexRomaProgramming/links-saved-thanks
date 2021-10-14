import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/helpers/build_snackbar.dart';
import 'package:links_saved_thanks/helpers/functions.dart';
import 'package:links_saved_thanks/models/link_info_model.dart';
import 'package:links_saved_thanks/widgets/background.dart';
import 'package:links_saved_thanks/widgets/bottom_bar.dart';

class MenuPage extends StatefulWidget {
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  final StorageController storageController = Get.find();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    //Every time we have new folder we will insert it in the list
    storageController.newFolderName.listen((value) {
      if (mounted) _insertListItem(value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //for keep alive

    return Scaffold(
      bottomNavigationBar: BottomBar(storageController: storageController),
      body: Stack(children: [
        const BackgroundWidget(),
        FadeInRight(
          delay: Duration(milliseconds: 500),
          duration: Duration(milliseconds: 500),
          child: SafeArea(
              child: SlidableNotificationListener(
            child: AnimatedList(
              key: listKey,
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              initialItemCount: storageController.folderList.length,
              itemBuilder: (context, index, animation) {
                final String text = storageController.folderList[index];
                final listOfCategory = storageController.allLinks
                    .where((element) => element.folder.contains(text))
                    .toList();
                //list sorted oldest items -> newest items
                listOfCategory.sort((a, b) => a.date.compareTo(b.date));
                return _animatedItem(
                    context, index, animation, text, listOfCategory);
              },
            ),
          )),
        )
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;

  //animation of list item when deleted or inserted
  Widget _animatedItem(BuildContext context, int index, animation, String text,
      List<LinkInfoModel> listOfCategory) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animation, curve: Curves.easeInOutQuad),
      child: _itemOfFolderList(index, text, listOfCategory),
    );
  }

  //list item
  Widget _itemOfFolderList(
      int index, String text, List<LinkInfoModel> listOfCategory) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Slidable(
        groupTag: '0',
        startActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.33,
            children: [
              SlidableAction(
                spacing: 8,
                backgroundColor: Colors.limeAccent.shade700,
                foregroundColor: Colors.black54,
                icon: FontAwesomeIcons.edit,
                label: 'Edit',
                onPressed: (context) {
                  _controller.text = text;
                  Get.defaultDialog(
                    title: 'Enter new folder name',
                    titleStyle: TextStyle(color: Colors.indigo.shade900),
                    backgroundColor: Colors.indigo.shade100,
                    buttonColor: Colors.indigo.shade900,
                    confirmTextColor: Colors.white,
                    cancelTextColor: Colors.indigo.shade900,
                    content: TextField(
                      style: TextStyle(
                          color: Colors.indigo.shade900,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                      controller: _controller,
                      onSubmitted: (value) {
                        _confirmNewFolderName(index, text);
                      },
                    ),
                    textConfirm: 'Confirm',
                    textCancel: 'Cancel',
                    onCancel: () {
                      _controller.clear();
                    },
                    onConfirm: () {
                      _confirmNewFolderName(index, text);
                    },
                  );
                },
              )
            ]),
        endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.33,
            children: [
              SlidableAction(
                spacing: 8,
                backgroundColor: Colors.deepOrangeAccent.shade400,
                foregroundColor: Colors.black54,
                icon: FontAwesomeIcons.trashAlt,
                label: 'Delete',
                onPressed: (context) {
                  _deleteFolder(text, index, listOfCategory);
                },
              )
            ]),
        child: ListTile(
          leading: Container(
              width: Get.width * 0.2,
              height: double.infinity,
              child: listOfCategory.isEmpty
                  ? Image.asset('assets/img/no-image.png',
                      width: double.infinity,
                      //height: 250,
                      fit: BoxFit.cover)
                  : imageToShow(listOfCategory.last.image, storageController)),
          title: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                listOfCategory.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 5),
              Icon(
                FontAwesomeIcons.list,
                size: 15,
                color: Colors.white,
              )
            ],
          ),
          onTap: () =>
              Get.toNamed('/folder', arguments: [text, '+not*from#search+']),
        ),
      ),
    );
  }

  void _confirmNewFolderName(int index, String foldersName) {
    if (_controller.text.trim() == '') {
      Get.back(); //from dialog

      buildSimpleSnackbar(
          'Error',
          'Enter at least one character',
          Icon(FontAwesomeIcons.exclamationCircle,
              color: Colors.deepOrangeAccent.shade400),
          false);
    } else if (_controller.text.trim() == foldersName) {
      Get.back();
    } else if (!storageController.folderList
        .contains(_controller.text.trim())) {
      String oldName = storageController.folderList[index];
      String newName = _controller.text.trim();
      //change the folder name for new one
      storageController.folderList[index] = newName;
      //change old name in all links
      storageController.allLinks.forEach((element) {
        if (element.folder.contains(oldName)) {
          int position = element.folder.indexOf(oldName);
          element.folder[position] = newName;
        }
      });
      Get.back();
      buildSimpleSnackbar(
          newName,
          'New folder name was created',
          Icon(FontAwesomeIcons.checkCircle, color: Colors.limeAccent.shade700),
          true);
    } else {
      Get.back();
      buildSimpleSnackbar(
          'Error',
          'The folder with this name already exists',
          Icon(FontAwesomeIcons.exclamationCircle,
              color: Colors.deepOrangeAccent.shade400),
          false);
    }

    _controller.clear();
    setState(() {});
  }

  void _deleteFolder(
      String text, int index, List<LinkInfoModel> listOfCategory) {
    List<int> voidPosition = []; //list of positions wich will be removed

    listKey.currentState!.removeItem(
        index,
        (context, animation) =>
            _animatedItem(context, index, animation, text, listOfCategory),
        duration: const Duration(milliseconds: 500));
    //delete the folder
    storageController.folderList.remove(text);
    storageController.allLinks.forEach((element) {
      //remove folder name in all places
      if (element.folder.contains(text)) element.folder.remove(text);
      if (element.folder.length == 0)
        //if a link don't has nothing in folder list remember its position
        voidPosition.add(storageController.allLinks.indexOf(element));
    });

    if (voidPosition.length > 0) {
      //sort from bigger to smaller for delete biggers first
      voidPosition.sort((a, b) => b.compareTo(a));
      //delete first biggers index for avoid shifting of elements
      voidPosition.forEach((position) {
        //remove link from search history
        storageController.searchHistoryList
            .remove(storageController.allLinks[position].title);
        //remove link from app
        storageController.allLinks.removeAt(position);
      });
    }
  }

  _insertListItem(String folderName) {
    listKey.currentState!
        .insertItem(0, duration: const Duration(milliseconds: 500));

    storageController.folderList.insert(0, folderName);
  }
}
