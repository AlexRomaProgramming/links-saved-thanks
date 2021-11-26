import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/helpers/functions.dart';

import 'package:links_saved_thanks/models/link_info_model.dart';

class LinkCard extends StatelessWidget {
  //Object which contains data
  final LinkInfoModel? dataFetched;
  final StorageController storageController = Get.find();

  LinkCard({Key? key, this.dataFetched}) : super(key: key); //constructor

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(20),
        height: Get.height * 0.33,
        width: MediaQuery.of(context).orientation == Orientation.landscape
            ? Get.height * 0.5
            : double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey.shade400,
            border:
                Border.all(color: Colors.blueGrey.shade300.withOpacity(0.8)),
            borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Align(child: imageToShow(dataFetched!.image, storageController)),
              FadeIn(
                  delay: Duration(milliseconds: 1000),
                  duration: Duration(milliseconds: 1000),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.blueGrey.shade700.withOpacity(0.2),
                                  Colors.blueGrey.shade700.withOpacity(0.8),
                                ])),
                        child: Text(
                          dataFetched!.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
