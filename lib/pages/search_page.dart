import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/widgets/background.dart';
import 'package:links_saved_thanks/widgets/bottom_bar.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StorageController storageController = Get.find();
    return Scaffold(
      bottomNavigationBar: BottomBar(storageController: storageController),
      body: Stack(children: [
        const BackgroundWidget(),
        Center(child: Text('Searching ...')),
      ]),
    );
  }
}
