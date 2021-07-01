import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/helpers/functions.dart';
import 'package:links_saved_thanks/models/link_info_model.dart';

import 'package:links_saved_thanks/widgets/background.dart';
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
                BackgroundWidget(),
                Column(
                  children: [
                    LinkCard(dataFetched: snapshot.data),
                    Row(
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            storageController.bottomBarIndex.value = 0;
                            Get.toNamed('menu');
                          },
                          child: Icon(Icons.print),
                        )
                      ],
                    ),
                  ],
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
