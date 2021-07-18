import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:links_saved_thanks/controllers/storage_controller.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
    required this.storageController,
  }) : super(key: key);

  final StorageController storageController;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: storageController.bottomBarIndex.value,
        onTap: (value) {
          storageController.bottomBarIndex.value = value;
          //TODO: switch ??? for default value
          if (value == 0) {
            Get.toNamed('menu');
          } else if (value == 1) {
            Get.toNamed('newFolder');
          } else if (value == 2) {
            Get.toNamed('search');
          }
        },
        backgroundColor: Colors.indigo.shade100,
        selectedItemColor: Colors.indigoAccent,
        //unselectedItemColor: Colors.white54,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.folder), label: 'New folder'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.search), label: 'Search')
        ]);
  }
}
