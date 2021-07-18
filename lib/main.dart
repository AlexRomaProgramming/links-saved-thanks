import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:links_saved_thanks/pages/home_page.dart';
import 'package:links_saved_thanks/pages/menu_page.dart';
import 'package:links_saved_thanks/pages/new_folder_page.dart';
import 'package:links_saved_thanks/pages/search_page.dart';

void main() async {
  await GetStorage.init('Data');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Links Saved Thanks',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      getPages: [
        GetPage(
            name: 'home',
            page: () => HomePage(),
            transition: Transition.fadeIn),
        GetPage(
            name: 'menu',
            page: () => MenuPage(),
            transition: Transition.fadeIn),
        GetPage(
            name: 'newFolder',
            page: () => NewFolderPage(),
            transition: Transition.fadeIn),
        GetPage(
            name: 'search',
            page: () => SearchPage(),
            transition: Transition.fadeIn),
      ],
    );
  }
}
