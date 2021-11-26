import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:links_saved_thanks/controllers/storage_controller.dart';

class BottomBar extends StatelessWidget {
  final StorageController storageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: storageController.bottomBarIndex.value,
        onTap: (value) {
          storageController.bottomBarIndex.value = value;

          switch (value) {
            case 0:
              if (storageController.isFromOutside.value) {
                Get.until((route) => Get.currentRoute == '/menu');
              } else {
                Get.until((route) => Get.currentRoute == '/home');
              }

              break;
            case 1:
              if (Get.previousRoute == '/intro' ||
                  Get.previousRoute == '/home' ||
                  Get.previousRoute == '/menu') {
                Get.toNamed('/newFolder');
              } else {
                Get.offNamed('/newFolder');
              }
              break;
            case 2:
              if (Get.previousRoute == '/intro' ||
                  Get.previousRoute == '/home' ||
                  Get.previousRoute == '/menu') {
                Get.toNamed('/search');
              } else {
                Get.offNamed('/search');
              }
              break;
          }
        },
        backgroundColor: Colors.indigo.shade100,
        selectedItemColor: Colors.indigoAccent,
        items: [
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home), label: 'Home'.tr),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.folder), label: 'New folder'.tr),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.search), label: 'Search'.tr)
        ]);
  }
}
