import 'dart:async';

import 'package:flutter/material.dart';

import 'package:links_saved_thanks/helpers/functions.dart';
import 'package:links_saved_thanks/models/link_info_model.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

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
    if (_sharedText != null && _sharedText != '') {
      return Scaffold(
        body: FutureBuilder(
          future: fetchLinkInfo(_sharedText!),
          builder:
              (BuildContext context, AsyncSnapshot<LinkInfoModel> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  SizedBox(height: 40),
                  Image.network(snapshot.data!.image),
                  SizedBox(height: 10),
                  Text(snapshot.data!.title),
                  SizedBox(height: 10),
                  Text(snapshot.data!.description)
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
}
