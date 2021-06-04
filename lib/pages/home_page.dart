import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/helpers/functions.dart';
import 'package:links_saved_thanks/models/link_info_model.dart';
import 'package:links_saved_thanks/widgets/linkCard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

        print("Shared: $_sharedText");
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      setState(() {
        _sharedText = value;

        print("Shared: $_sharedText");
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
    final StorageController storageController = Get.put(StorageController());
    if (_sharedText != null && _sharedText != '') {
      return Scaffold(
        body: FutureBuilder(
          future: fetchLinkInfo(_sharedText!),
          builder:
              (BuildContext context, AsyncSnapshot<LinkInfoModel> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  LinkCard(dataFetched: snapshot.data),
                  Row(
                    children: [
                      FloatingActionButton(
                          onPressed: () {
                            storageController.allLinks.add(snapshot.data!);
                          },
                          child: Icon(Icons.add)),
                      FloatingActionButton(
                        onPressed: () {
                          storageController.allLinks.forEach((element) {
                            print(element.title);
                          });
                        },
                        child: Icon(Icons.print),
                      )
                    ],
                  ),
                  ...controlTexts(storageController)
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Snapshot has error !!!'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
    } else {
      return Scaffold(
        body: Center(child: Text('Sin datos !!!')),
      );
    }
  }

  List<Widget> controlTexts(StorageController controller) {
    var list = <Widget>[];
    if (controller.allLinks.isEmpty) {
      list.add(Text('nada que mostrar'));
    } else {
      controller.allLinks.forEach((element) {
        list.add(Text(element.title));
      });
    }
    return list;
  }
}
