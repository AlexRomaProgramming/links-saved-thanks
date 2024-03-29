import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/helpers/translated_strings.dart';
import 'package:links_saved_thanks/pages/error_page.dart';
import 'package:links_saved_thanks/pages/home_page.dart';
import 'package:links_saved_thanks/pages/folder_page.dart';
import 'package:links_saved_thanks/pages/intro_page.dart';
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
  final StorageController storageController = Get.put(StorageController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for dismiss keyboard with click anywhere
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: GetMaterialApp(
        title: 'Links Saved Thanks',
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.indigo.shade200,
            primaryColor: Colors.indigo.shade900),
        debugShowCheckedModeBanner: false,
        initialRoute: '/intro',
        getPages: [
          GetPage(name: '/intro', page: () => IntroPage()),
          GetPage(
              name: '/home',
              page: () => HomePage(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/menu',
              page: () => MenuPage(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/newFolder',
              page: () => NewFolderPage(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/search',
              page: () => SearchPage(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/folder',
              page: () => FolderPage(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/error',
              page: () => ErrorPage(),
              transition: Transition.fadeIn),
        ],
        locale: Get.deviceLocale,
        fallbackLocale: Locale('en'),
        translations: TranslatedStrings(),
      ),
    );
  }
}
