import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:links_saved_thanks/pages/home_page.dart';

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
        home: HomePage());
  }
}
