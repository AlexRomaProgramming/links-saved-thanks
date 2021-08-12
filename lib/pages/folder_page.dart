import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/widgets/background.dart';
import 'package:links_saved_thanks/widgets/links_list_view.dart';

class FolderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //name of folder come with arguments from previous page
    final String folderName = Get.arguments;
    final StorageController storageController = Get.find();
    //list for this folder
    final listOfCategory = storageController.allLinks
        .where((element) => element.folder.contains(folderName))
        .toList();
    listOfCategory.sort((a, b) => a.date.compareTo(b.date));
    final ScrollController _controller = ScrollController(
        initialScrollOffset:
            (Get.height * 0.36) * (storageController.allLinks.length - 1));
    return Scaffold(
        body: Stack(
      children: [
        const BackgroundWidget(),
        Column(
          children: [
            SafeArea(
              child: Container(
                height: Get.height * 0.065,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.white,
                        )),
                    Spacer(),
                    Container(
                      constraints: BoxConstraints(maxWidth: Get.width * 0.8),
                      child: Text(folderName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 22)),
                    ),
                    Spacer()
                  ],
                ),
              ),
            ),
            Expanded(
              child: LinksListView(
                  controller: _controller, selectedList: listOfCategory),
            )
          ],
        )
      ],
    ));
  }
}
