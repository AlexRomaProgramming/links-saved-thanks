import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:links_saved_thanks/models/link_info_model.dart';

//Widget card-type, is stateful due to reset animation controller
//Animation repeat with updated data
class LinkCard extends StatefulWidget {
  //Object which contains data
  final LinkInfoModel? dataFetched;

  LinkCard({Key? key, this.dataFetched}) : super(key: key); //constructor

  @override
  State<LinkCard> createState() => _LinkCardState();
}

class _LinkCardState extends State<LinkCard> {
  //controller for animation
  late final AnimationController aCtrlTextUp;

  //each time we rebuild widget it restart the animation
  @override
  void didUpdateWidget(covariant LinkCard oldWidget) {
    //if is the same card - don´t start animation
    if (widget.dataFetched!.title != oldWidget.dataFetched!.title) {
      aCtrlTextUp
        ..reset()
        ..forward();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    aCtrlTextUp.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(15),
        height: 300,
        decoration: BoxDecoration(
            color: Colors.grey[400],
            border: Border.all(color: Colors.brown.withOpacity(0.6)),
            borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (widget.dataFetched!.image == 'no_image')
                Image.asset('assets/img/no-image.png',
                    width: double.infinity,
                    //height: 250,
                    fit: BoxFit.fill)
              else
                FadeInImage.assetNetwork(
                    height: 300,
                    fit: BoxFit.fitHeight,
                    placeholder: 'assets/img/jar-loading.gif',
                    image: widget.dataFetched!.image),
              FadeIn(
                  controller: (controller) => aCtrlTextUp = controller,
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
                                  Colors.brown.withOpacity(0.2),
                                  Colors.brown.withOpacity(0.8),
                                ])),
                        child: Text(
                          widget.dataFetched!.title,
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
