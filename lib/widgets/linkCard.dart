import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';

import 'package:links_saved_thanks/models/link_info_model.dart';

class LinkCard extends StatelessWidget {
  //Object which contains data
  final LinkInfoModel? dataFetched;

  LinkCard({Key? key, this.dataFetched}) : super(key: key); //constructor

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(15),
        height: Get.height * 0.3,
        decoration: BoxDecoration(
            color: Colors.grey[400],
            border:
                Border.all(color: Colors.blueGrey.shade300.withOpacity(0.8)),
            borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (dataFetched!.image == 'no_image')
                Image.asset('assets/img/no-image.png',
                    width: double.infinity, fit: BoxFit.cover)
              else
                FadeInImage.assetNetwork(
                    height: Get.height * 0.36,
                    fit: BoxFit.cover,
                    placeholder: 'assets/img/jar-loading.gif',
                    image: dataFetched!.image),
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
