import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/helpers/functions.dart';
import 'package:links_saved_thanks/models/link_info_model.dart';

import 'package:links_saved_thanks/widgets/background.dart';

import 'package:links_saved_thanks/widgets/line_of_folders.dart';
import 'package:links_saved_thanks/widgets/linkCard.dart';

class CardPage extends StatelessWidget {
  const CardPage({
    Key? key,
    required String? sharedText,
    required this.storageController,
  })  : _sharedText = sharedText,
        super(key: key);

  final String? _sharedText;
  final StorageController storageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchLinkInfo(_sharedText!),
        builder: (BuildContext context, AsyncSnapshot<LinkInfoModel> snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                const BackgroundWidget(),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          storageController.bottomBarIndex.value = 0;
                          Get.toNamed('menu');
                        },
                        child: Container(
                          margin: EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.arrowLeft,
                                  color: Colors.white),
                              SizedBox(width: 5),
                              Icon(FontAwesomeIcons.home, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      Draggable(
                          data: snapshot.data,
                          dragAnchorStrategy: pointerDragAnchorStrategy,
                          //childWhenDragging: Container(),
                          feedback: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 100,
                              width: 150,
                              child: (snapshot.data!.image == 'no_image')
                                  ? Image.asset('assets/img/no-image.png',
                                      width: double.infinity,
                                      //height: 250,
                                      fit: BoxFit.cover)
                                  : FadeInImage.assetNetwork(
                                      //height: Get.height * 0.36,
                                      fit: BoxFit.cover,
                                      placeholder: 'assets/img/jar-loading.gif',
                                      image: snapshot.data!.image),
                            ),
                          ),
                          child: LinkCard(dataFetched: snapshot.data)),
                      Text(
                        'Drag the card and drop in the folder of you choice',
                        style: TextStyle(
                            fontSize: 18, color: Colors.white.withOpacity(0.5)),
                      ),
                      FadeInDown(
                        child: Icon(FontAwesomeIcons.arrowDown,
                            size: 100, color: Colors.white.withOpacity(0.3)),
                      ),
                      Spacer(),

                      //TODO: When i remove a folder and go back to card page
                      //(with back button) deleted folder is visible in this list
                      //tips: use Get.offNamed() instead of Get.toNamed()
                      LineOfFolders(folderList: storageController.folderList)
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            //TODO: do something with it
            return Center(child: Text('Snapshot has error !!!'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
