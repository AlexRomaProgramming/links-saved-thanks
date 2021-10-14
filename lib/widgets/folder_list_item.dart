import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/models/link_info_model.dart';

class FolderListItem extends StatelessWidget {
  final String text;

  const FolderListItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StorageController storageController = Get.find();
    return GestureDetector(
      onTap: () =>
          Get.toNamed('/folder', arguments: [text, '+not*from#search+']),
      child: DragTarget<LinkInfoModel>(
        builder: (BuildContext context, List<Object?> candidateData,
            List<dynamic> rejectedData) {
          return Container(
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListItemContainer(
                    text: text, highlighted: candidateData.isNotEmpty),
              ],
            ),
          );
        },
        onAccept: (data) {
          LinkInfoModel newItem = data;
          storageController.bottomBarIndex.value = 0;
          //if link exists in storage list find its position
          int positionInList = storageController.positionIfUrlExists(data.url);
          //if link is new position -1
          if (positionInList == -1) {
            newItem.folder.add(text);
            storageController.allLinks.add(newItem);
          } else {
            //if no exist this folder name for this link
            if (!storageController.allLinks[positionInList].folder
                .contains(text)) {
              //new folder name added
              storageController.allLinks[positionInList].folder.add(text);
              //must trigger rewriting of allLinksList, property of an element of the list will change
              storageController.recordLinkList(storageController.allLinks);
            }
            //put new datetame, will sort by date in folder page
            storageController.allLinks[positionInList].date = DateTime.now();
          }
          Get.toNamed('/menu');
        },
      ),
    );
  }
}

class ListItemContainer extends StatelessWidget {
  const ListItemContainer({
    Key? key,
    required this.text,
    this.highlighted = false,
  }) : super(key: key);

  final String text;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: highlighted ? 1.15 : 1.0,
      child: Container(
        constraints: BoxConstraints(maxWidth: Get.width * 0.5),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: highlighted ? Colors.black : Colors.white, fontSize: 16),
        ),
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: highlighted
                ? Colors.limeAccent.shade700
                : Colors.indigo.shade900,
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
