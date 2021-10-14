import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/widgets/background.dart';
import 'package:links_saved_thanks/widgets/links_list_view.dart';

class FolderPage extends StatelessWidget {
  //name of folder come with arguments from previous page
  final String folderName = Get.arguments[0]; //folder name
  final String searchedLinkTitle =
      Get.arguments[1]; //if is from search - title of searched link
  final StorageController storageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        const BackgroundWidget(),
        FadeIn(
          delay: Duration(milliseconds: 500),
          duration: Duration(milliseconds: 500),
          child: Column(
            children: [
              Container(
                color: Colors.indigo.shade900,
                height: Get.height * 0.065 + MediaQuery.of(context).padding.top,
                child: Container(
                  margin:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.until((route) =>
                                Get.currentRoute == '/menu' ||
                                Get.currentRoute == '/home');
                            storageController.bottomBarIndex.value = 0;
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 22)),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ),
              Expanded(
                child: LinksListView(
                    folderName: folderName,
                    searchedLinkTitle: searchedLinkTitle),
              )
            ],
          ),
        )
      ],
    ));
  }
}
