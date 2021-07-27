import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import 'package:links_saved_thanks/models/link_info_model.dart';

class LinksListView extends StatelessWidget {
  const LinksListView({
    Key? key,
    required ScrollController controller,
    required this.selectedList,
  })  : _controller = controller,
        super(key: key);

  final ScrollController _controller;
  final List<LinkInfoModel> selectedList;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      delay: Duration(milliseconds: 500),
      duration: Duration(milliseconds: 500),
      child: Container(
        child: ListView.builder(
          padding: EdgeInsets.only(
              bottom: (Get.height * 0.64) -
                  MediaQuery.of(context).padding.top -
                  Get.height * 0.065),
          reverse: true,
          physics: BouncingScrollPhysics(),
          controller: _controller,
          itemCount: selectedList.length,
          itemBuilder: (context, index) {
            return Material(
              color: Colors.grey[300],
              child: StickyHeaderBuilder(
                overlapHeaders: true,
                builder: (BuildContext context, double stuckAmount) {
                  stuckAmount = 1.0 - stuckAmount.clamp(0.0, 1.0);
                  return Container(
                    height: 50.0,
                    color: Colors.indigo.shade300
                        .withOpacity(0.6 + stuckAmount * 0.4),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 14,
                          child: Text(
                            selectedList[index].title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Offstage(
                            offstage: stuckAmount <= 0.0,
                            child: Opacity(
                              opacity: stuckAmount,
                              child: IconButton(
                                icon: Icon(FontAwesomeIcons.trashAlt,
                                    color: Colors.white),
                                onPressed: () => ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text('Favorite #$index'))),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                content: Container(
                    color: Colors.grey.shade400,
                    alignment: Alignment.center,
                    child: (selectedList[index].image == 'no_image')
                        ? Image.asset('assets/img/no-image.png',
                            width: double.infinity,
                            height: Get.height * 0.36,
                            fit: BoxFit.cover)
                        : FadeInImage.assetNetwork(
                            height: Get.height * 0.36,
                            fit: BoxFit.cover,
                            placeholder: 'assets/img/jar-loading.gif',
                            image: selectedList[index].image)),
              ),
            );
          },
        ),
      ),
    );
  }
}
