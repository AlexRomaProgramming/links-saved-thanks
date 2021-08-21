import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import 'package:links_saved_thanks/controllers/storage_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final listOfCategory = storageController.allLinks
        .where((element) => element.folder.contains(widget.folderName))
        .toList();
    listOfCategory.sort((a, b) => b.date.compareTo(a.date));
    return FadeIn(
      delay: Duration(milliseconds: 500),
      duration: Duration(milliseconds: 500),
      child: Container(
        child: AnimatedList(
          key: listKey,
          padding: EdgeInsets.only(
              bottom: (Get.height * 0.64) -
                  MediaQuery.of(context).padding.top -
                  Get.height * 0.065),
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
    return Material(
      color: Colors.grey[300],
      child: StickyHeaderBuilder(
        overlapHeaders: true,
        builder: (BuildContext context, double stuckAmount) {
          stuckAmount = 1.0 - stuckAmount.clamp(0.0, 1.0);
          return Container(
            height: 50.0,
            color: Colors.indigo.shade300.withOpacity(0.6 + stuckAmount * 0.4),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Flexible(
                  flex: 14,
                  fit: FlexFit.tight,
                  child: Text(
                    listofCategory[index].title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Offstage(
                    offstage: stuckAmount <= 0.0,
                    child: Opacity(
                      opacity: stuckAmount,
                      child: IconButton(
                          icon: Icon(FontAwesomeIcons.trashAlt,
                              color: Colors.white),
                          onPressed: () {
                            _deleteLink(index, listofCategory);
                          }),
                    ),
                  ),
                )
              ],
            ),
          );
        },
        content: Container(
            color: Colors.grey.shade400,
            alignment: Alignment.center,
            child: (listofCategory[index].image == 'no_image')
                ? Image.asset('assets/img/no-image.png',
                    width: double.infinity,
                    height: Get.height * 0.36,
                    fit: BoxFit.cover)
                : FadeInImage.assetNetwork(
                    height: Get.height * 0.36,
                    fit: BoxFit.cover,
                    placeholder: 'assets/img/jar-loading.gif',
                    image: listofCategory[index].image)),
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
        if (element.title == removableLinkTitle) {
          element.folder.remove(widget.folderName);

          if (element.folder.isEmpty) {
            position = storageController.allLinks.indexOf(element);
          } else {
            storageController.recordLinkList(storageController.allLinks);
          }
        }
      });
      if (position >= 0) storageController.allLinks.removeAt(position);
    });
  }
}
