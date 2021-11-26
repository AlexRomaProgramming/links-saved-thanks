import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:links_saved_thanks/pages/menu_page.dart';
import 'package:links_saved_thanks/pages/card_page.dart';
import 'package:links_saved_thanks/controllers/storage_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final StorageController storageController = Get.find();
  late StreamSubscription _intentDataStreamSubscription;
  late StreamSubscription _internetConnectionSubscription;
  String? _sharedText; //url of the shared site

  @override
  void initState() {
    super.initState();

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
        //return to home page, its a bottom of the Stack
        Get.until((route) => Get.currentRoute == '/home');
      });
    }, onError: (err) {
      Get.toNamed('/error');
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      setState(() {
        _sharedText = value;
      });
    });

    _internetConnectionSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        storageController.isInternetConnected.value = true;
      } else {
        storageController.isInternetConnected.value = false;
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    _internetConnectionSubscription.cancel();
    super.dispose();
  }

  @override
  //method equivalent to onResume() of Android
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      //check the connectivity
      var connectivityResult = await (Connectivity().checkConnectivity());
      //true if we have connection, false if not
      if (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile) {
        storageController.isInternetConnected.value = true;
      } else {
        storageController.isInternetConnected.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //if we have a link and it not return with error -> cardPage
    if (_sharedText != null &&
        _sharedText != '' &&
        _sharedText != storageController.linkWithError.value) {
      storageController.isFromOutside.value = true;
      return WillPopScope(
        onWillPop: _backButtonOverride,
        child: CardPage(sharedText: _sharedText),
      );
    } else {
      //another way start with menuPage
      storageController.isFromOutside.value = false;
      return WillPopScope(onWillPop: _backButtonOverride, child: MenuPage());
    }
  }

  //back button will open dialog asking if we want close the app
  Future<bool> _backButtonOverride() async {
    bool wantExit = false;
    await Get.defaultDialog(
      title: 'Do you want to exit the app?'.tr,
      content: Container(),
      titleStyle: TextStyle(color: Colors.indigo.shade900),
      backgroundColor: Colors.indigo.shade100,
      buttonColor: Colors.indigo.shade900,
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.indigo.shade900,
      textConfirm: 'Yes'.tr,
      textCancel: 'No'.tr,
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
