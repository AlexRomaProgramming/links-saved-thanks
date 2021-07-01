import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:links_saved_thanks/pages/menu_page.dart';
import 'package:links_saved_thanks/pages/card_page.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:links_saved_thanks/controllers/storage_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription _intentDataStreamSubscription;
  String? _sharedText;
  final StorageController storageController = Get.find();

  @override
  void initState() {
    super.initState();

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
        print("Shared when in memory: $_sharedText");
        //return to home page, is a bottom of the Stack
        Get.until((route) => Get.currentRoute == 'home');
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      setState(() {
        _sharedText = value;

        print("Shared from cold: $_sharedText");
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_sharedText != null && _sharedText != '') {
      return CardPage(
          sharedText: _sharedText, storageController: storageController);
    } else {
      //TODO: When started from cold shows this screen a fraction of second, need fix

      return MenuPage(storageController.folderList);
    }
  }
}
