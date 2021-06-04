import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:links_saved_thanks/models/link_info_model.dart';

//Widget card-type, is stateful due to reset animation controllers
//Animation repeat with updated data
class LinkCard extends StatefulWidget {
  //Object wich contains data
  final LinkInfoModel? dataFetched;

  LinkCard({Key? key, this.dataFetched}) : super(key: key); //constructor

  @override
  State<LinkCard> createState() => _LinkCardState();
}

class _LinkCardState extends State<LinkCard> {
  //controllers for each animation
  late final AnimationController aCtrlTextUp;
  late final AnimationController aCtrlTextDown;

  //each time we rebuild widget it restart the animation
  @override
  void didUpdateWidget(covariant LinkCard oldWidget) {
    //if is the same card - don´t start animation
    if (widget.dataFetched!.title != oldWidget.dataFetched!.title) {
      aCtrlTextUp
        ..reset()
        ..forward();
      aCtrlTextDown
        ..reset()
        ..forward();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    aCtrlTextUp.dispose();
    aCtrlTextDown.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(border: Border.all(color: Colors.green)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeInLeft(
                controller: (controller) => aCtrlTextUp = controller,
                delay: Duration(milliseconds: 500),
                duration: Duration(milliseconds: 1000),
                child: Text(widget.dataFetched!.title)),
            SizedBox(height: 10),
            if (widget.dataFetched!.image == 'no_image')
              Image.asset('assets/img/no-image.png',
                  height: 300, fit: BoxFit.contain)
            else
              FadeInImage.assetNetwork(
                  height: 300,
                  fit: BoxFit.contain,
                  placeholder: 'assets/img/jar-loading.gif',
                  image: widget.dataFetched!.image),
            //Image.network(dataFetched!.image),
            SizedBox(height: 10),
            FadeInRight(
                controller: (controller) => aCtrlTextDown = controller,
                delay: Duration(milliseconds: 500),
                duration: Duration(milliseconds: 1000),
                child: Text(widget.dataFetched!.description))
          ],
        ),
      ),
    );
  }
}
