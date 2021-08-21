import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:links_saved_thanks/pages/home_page.dart';
import 'package:links_saved_thanks/pages/folder_page.dart';
import 'package:links_saved_thanks/pages/menu_page.dart';
import 'package:links_saved_thanks/pages/new_folder_page.dart';
import 'package:links_saved_thanks/pages/search_page.dart';

void main() async {
  await GetStorage.init('Data');
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Links Saved Thanks',
      theme: ThemeData(scaffoldBackgroundColor: Colors.indigo.shade200),
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
        GetPage(
            name: 'folder',
            page: () => FolderPage(),
            transition: Transition.fadeIn),
      ],
    );
  }
}
