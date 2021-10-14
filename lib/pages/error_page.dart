import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/widgets/background.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StorageController storageController = Get.find();
    return Scaffold(
        body: Stack(
      children: [
        const BackgroundWidget(),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    storageController.isFromOutside.value = false;
                    Get.offAllNamed('/home');
                  },
                  icon: Icon(FontAwesomeIcons.arrowLeft),
                  color: Colors.white,
                ),
              ),
              Center(
                child: Icon(
                  FontAwesomeIcons.exclamationTriangle,
                  color: Colors.white54,
                  size: 100,
                ),
              ),
              Text(
                'Something went wrong...',
                style: TextStyle(color: Colors.white70, fontSize: 28),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        )
      ],
    ));
  }
}
