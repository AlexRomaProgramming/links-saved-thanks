import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:links_saved_thanks/pages/menu_page.dart';
import 'package:links_saved_thanks/pages/card_page.dart';
import 'package:links_saved_thanks/controllers/storage_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageController storageController = Get.find();
  late StreamSubscription _intentDataStreamSubscription;
  String? _sharedText;

  @override
  void initState() {
    super.initState();

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
        print("Shared when in memory: $_sharedText");
        //return to home page, its a bottom of the Stack
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
      storageController.isFromOutside.value = true;
      return WillPopScope(
        onWillPop: _backButtonOverride,
        child: CardPage(sharedText: _sharedText),
      );
    } else {
      storageController.isFromOutside.value = false;
      return WillPopScope(onWillPop: _backButtonOverride, child: MenuPage());
    }
  }

  Future<bool> _backButtonOverride() async {
    bool wantExit = false;
    await Get.defaultDialog(
      title: 'Do you want to exit the app?',
      content: Container(),
      titleStyle: TextStyle(color: Colors.indigo.shade900),
      backgroundColor: Colors.indigo.shade100,
      buttonColor: Colors.indigo.shade900,
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.indigo.shade900,
      textConfirm: 'Yes',
      textCancel: 'No',
      onCancel: () {
        wantExit = false;
      },
      onConfirm: () {
        Get.back();
        wantExit = true;
      },
    );
    return wantExit;
  }
}
