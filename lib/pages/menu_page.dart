import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/widgets/background.dart';
import 'package:links_saved_thanks/widgets/bottom_bar.dart';
import 'package:links_saved_thanks/widgets/folder_list_item.dart';

class MenuPage extends StatelessWidget {
  final List<String> folderList;
  MenuPage(this.folderList);

  @override
  Widget build(BuildContext context) {
    final StorageController storageController = Get.find();
    return Scaffold(
      bottomNavigationBar: BottomBar(storageController: storageController),
      body: Stack(children: [
        BackgroundWidget(),
        Column(
          children: [
            SafeArea(
              child: Container(
                height: 50,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: folderList.length,
                  itemBuilder: (context, index) =>
                      Center(child: FolderListItem(text: folderList[index])),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
