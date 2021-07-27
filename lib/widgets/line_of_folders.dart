import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:links_saved_thanks/widgets/folder_list_item.dart';

class LineOfFolders extends StatelessWidget {
  const LineOfFolders({
    Key? key,
    required this.folderList,
  }) : super(key: key);

  final List<String> folderList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FadeInRight(
        delay: Duration(milliseconds: 1000),
        duration: Duration(milliseconds: 500),
        child: Container(
          height: Get.height * 0.065,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: folderList.length,
            itemBuilder: (context, index) =>
                Center(child: FolderListItem(text: folderList[index])),
          ),
        ),
      ),
    );
  }
}
