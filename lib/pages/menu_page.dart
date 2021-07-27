import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/widgets/background.dart';
import 'package:links_saved_thanks/widgets/bottom_bar.dart';

class MenuPage extends StatefulWidget {
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context); //for keep alive
    final StorageController storageController = Get.find();
    final allLinksList = storageController.allLinks.toList();
    return Scaffold(
      bottomNavigationBar: BottomBar(storageController: storageController),
      body: Stack(children: [
        BackgroundWidget(),
        FadeInRight(
          delay: Duration(milliseconds: 500),
          duration: Duration(milliseconds: 500),
          child: SafeArea(
              child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: storageController.folderList.length,
            itemBuilder: (context, index) {
              final String text = storageController.folderList[index];
              final listOfCategory = allLinksList
                  .where((element) => element.folder.contains(text))
                  .toList();
              listOfCategory.sort((a, b) => a.date.compareTo(b.date));
              return ListTile(
                leading: Container(
                    width: Get.width * 0.2,
                    height: double.infinity,
                    child: (listOfCategory.isEmpty ||
                            listOfCategory.last.image == 'no_image')
                        ? Image.asset('assets/img/no-image.png',
                            width: double.infinity,
                            height: Get.height * 0.36,
                            fit: BoxFit.cover)
                        : FadeInImage.assetNetwork(
                            height: Get.height * 0.36,
                            fit: BoxFit.cover,
                            placeholder: 'assets/img/jar-loading.gif',
                            image: listOfCategory.last.image)),
                title: Text(
                  text,
                  style: TextStyle(color: Colors.white),
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
                onTap: () => Get.toNamed('folder', arguments: text),
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(),
          )),
        )
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
