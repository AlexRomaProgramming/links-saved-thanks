import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/widgets/background.dart';
import 'package:links_saved_thanks/widgets/bottom_bar.dart';
import 'package:links_saved_thanks/widgets/line_of_folders.dart';

class MenuPage extends StatefulWidget {
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final StorageController storageController = Get.find();
    ScrollController _controller = ScrollController(
        initialScrollOffset:
            (Get.height * 0.36) * (storageController.allLinks.length - 1));
    return Scaffold(
      bottomNavigationBar: BottomBar(storageController: storageController),
      body: Stack(children: [
        BackgroundWidget(),
        Column(
          children: [
            LineOfFolders(folderList: storageController.folderList),
            Expanded(
              child: FadeIn(
                delay: Duration(milliseconds: 500),
                duration: Duration(milliseconds: 500),
                child: Container(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: (Get.height * 0.64) - 130),
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    controller: _controller,
                    itemCount: storageController.allLinks.length,
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
                                      storageController.allLinks[index].title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
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
                                          onPressed: () =>
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Favorite #$index'))),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          content: Container(
                              alignment: Alignment.center,
                              child: (storageController.allLinks[index].image ==
                                      'no_image')
                                  ? Image.asset('assets/img/no-image.png',
                                      width: double.infinity,
                                      height: Get.height * 0.36,
                                      fit: BoxFit.fitWidth)
                                  : FadeInImage.assetNetwork(
                                      height: Get.height * 0.36,
                                      fit: BoxFit.fitHeight,
                                      placeholder: 'assets/img/jar-loading.gif',
                                      image: storageController
                                          .allLinks[index].image)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
