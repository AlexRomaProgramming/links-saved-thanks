import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/helpers/build_snackbar.dart';
import 'package:links_saved_thanks/models/link_info_model.dart';

class LinksListView extends StatefulWidget {
  LinksListView({Key? key, required this.folderName}) : super(key: key);

  final String folderName;

  @override
  State<LinksListView> createState() => _LinksListViewState();
}

class _LinksListViewState extends State<LinksListView>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  final StorageController storageController = Get.find();
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //list of links in this folder
    final listOfCategory = storageController.allLinks
        .where((element) => element.folder.contains(widget.folderName))
        .toList();
    //sorted for leave new links above old ones
    listOfCategory.sort((a, b) => b.date.compareTo(a.date));
    return FadeIn(
      delay: Duration(milliseconds: 500),
      duration: Duration(milliseconds: 500),
      child: SlidableNotificationListener(
        child: AnimatedList(
          key: listKey,
          physics: BouncingScrollPhysics(),
          initialItemCount: listOfCategory.length,
          itemBuilder: (context, index, animation) {
            return _animatedListItem(context, index, animation, listOfCategory);
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _animatedListItem(BuildContext context, int index,
      Animation<double> animation, List<LinkInfoModel> listofCategory) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animation, curve: Curves.easeInOutQuad),
      child: _listItem(index, listofCategory),
    );
  }

  Widget _listItem(int index, List<LinkInfoModel> listofCategory) {
    return Column(
      children: [
        Slidable(
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
                      Get.defaultDialog(
                        title: 'Enter new title',
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
                        ),
                        textConfirm: 'Confirm',
                        textCancel: 'Cancel',
                        onCancel: () {
                          _controller.clear();
                        },
                        onConfirm: () {
                          _confirmNewTitle(index, listofCategory);
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
                      _deleteLink(index, listofCategory);
                    },
                  )
                ]),
            child: _listItemCard(listofCategory, index)),
        Container(
          height: 20,
        )
      ],
    );
  }

  Widget _listItemCard(List<LinkInfoModel> listofCategory, int index) {
    return GestureDetector(
      onTap: () {
        _launchUrl(listofCategory, index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
            child: Container(
                color: Colors.grey.shade400,
                alignment: Alignment.center,
                child: (listofCategory[index].image == 'no_image')
                    ? Image.asset('assets/img/no-image.png',
                        width: double.infinity,
                        height: Get.height * 0.33,
                        fit: BoxFit.cover)
                    : FadeInImage.assetNetwork(
                        height: Get.height * 0.33,
                        fit: BoxFit.cover,
                        placeholder: 'assets/img/jar-loading.gif',
                        image: listofCategory[index].image)),
          ),
          Container(
            height: Get.height * 0.08,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(30))),
            child: Text(
              listofCategory[index].title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  void _deleteLink(int index, List<LinkInfoModel> listOfCategory) {
    int position = -1;
    setState(() {
      listKey.currentState!.removeItem(
          index,
          (context, animation) =>
              _animatedListItem(context, index, animation, listOfCategory),
          duration: const Duration(milliseconds: 500));

      String removableLinkTitle = listOfCategory[index].title;

      storageController.allLinks.forEach((element) {
        //search an element with title wich will be removed
        if (element.title == removableLinkTitle) {
          //remove folder name from array 'folder'
          element.folder.remove(widget.folderName);
          //when array 'folder' is empty remove link
          if (element.folder.isEmpty) {
            //remember position of link to be removed
            position = storageController.allLinks.indexOf(element);
          } else {
            //rewrite allLinks with changes in 'folder' array
            storageController.recordLinkList(storageController.allLinks);
          }
        }
      });
      //if we have removable position - remove it
      if (position >= 0) storageController.allLinks.removeAt(position);
    });
  }

  void _confirmNewTitle(int index, List<LinkInfoModel> listOfCategory) {
    //create list with all titles
    List<String> titles = [];
    storageController.allLinks.forEach((element) {
      titles.add(element.title);
    });

    if (_controller.text.trim() == '') {
      Get.back();

      buildSimpleSnackbar(
          'Error',
          'Enter at least one character',
          Icon(FontAwesomeIcons.exclamationCircle,
              color: Colors.deepOrangeAccent.shade400),
          false);
      //if title is not repeated
    } else if (!titles.contains(_controller.text.trim())) {
      String newTitle = _controller.text.trim();
      String linksUrl = listOfCategory[index].url;
      //change title in local list
      listOfCategory[index].title = newTitle;
      //change title in global list
      storageController.allLinks.forEach((element) {
        if (element.url == linksUrl) {
          element.title = newTitle;
          //save changes of title field in global list
          storageController.recordLinkList(storageController.allLinks);
        }
      });

      Get.back();
      buildSimpleSnackbar(
          _controller.text,
          'New title was created',
          Icon(FontAwesomeIcons.checkCircle, color: Colors.limeAccent.shade700),
          true);
    } else {
      Get.back();
      buildSimpleSnackbar(
          'Error',
          'The title already exists',
          Icon(FontAwesomeIcons.exclamationCircle,
              color: Colors.deepOrangeAccent.shade400),
          false);
    }

    _controller.clear();
    setState(() {});
  }

  _launchUrl(List<LinkInfoModel> listofCategory, int index) async {
    final url = listofCategory[index].url;
    if (await canLaunch(url)) {
      //package url_launcher used
      await launch(url);
    } else {
      buildSimpleSnackbar(
          'Error',
          'Could not launch this page',
          Icon(FontAwesomeIcons.exclamationCircle,
              color: Colors.deepOrangeAccent.shade400),
          false);
    }
  }
}
