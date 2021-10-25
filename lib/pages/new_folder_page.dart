import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/widgets/background.dart';
import 'package:links_saved_thanks/widgets/bottom_bar.dart';

class NewFolderPage extends StatefulWidget {
  @override
  State<NewFolderPage> createState() => _NewFolderPageState();
}

class _NewFolderPageState extends State<NewFolderPage> {
  late TextEditingController _controller;
  bool textFieldEnabled = true;
  final StorageController storageController = Get.find();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, //for avoid resizing of layout with keyboard
      bottomNavigationBar: BottomBar(storageController: storageController),
      body: Stack(children: [
        const BackgroundWidget(),
        FadeInRight(
          delay: Duration(milliseconds: 500),
          duration: Duration(milliseconds: 500),
          child: Column(
            children: [
              SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      TextField(
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22),
                        enabled: textFieldEnabled,
                        controller: _controller,
                        onSubmitted: (value) {
                          _saveEdited();
                        },
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.indigo.shade900,
                            prefixIcon: Icon(
                              FontAwesomeIcons.folderOpen,
                              color: Colors.white38,
                            ),
                            hintText: 'Enter folder name...'.tr,
                            hintStyle:
                                TextStyle(color: Colors.white38, fontSize: 22),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30))),
                      ),
                      SizedBox(height: 30),
                      OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.indigo.shade900),
                              primary: Colors.limeAccent.shade400),
                          onPressed: _saveEdited,
                          icon: Icon(
                            FontAwesomeIcons.fileDownload,
                            color: Colors.indigo.shade900,
                          ),
                          label: Text(
                            'Save'.tr,
                            style: TextStyle(
                                fontSize: 22, color: Colors.indigo.shade900),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void _saveEdited() {
    //remove keyboard
    FocusScope.of(context).unfocus();
    if (!Get.isSnackbarOpen!) {
      if (_controller.text.trim() == '') {
        _buildSnackbar(
            'Error'.tr,
            'Enter at least one character'.tr,
            Icon(FontAwesomeIcons.exclamationCircle,
                color: Colors.deepOrangeAccent.shade400),
            false);
      } else if (!storageController.folderList.contains(_controller.text)) {
        storageController.newFolderName.value = _controller.text.trim();
        storageController.bottomBarIndex.value = 0;

        if (storageController.isFromOutside.value) {
          Get.until((route) => Get.currentRoute == '/menu');
        } else {
          Get.until((route) => Get.currentRoute == '/home');
        }

        _buildSnackbar(
            _controller.text,
            'This folder has been added to the list'.tr,
            Icon(FontAwesomeIcons.checkCircle,
                color: Colors.limeAccent.shade700),
            true);
      } else {
        _buildSnackbar(
            'Error'.tr,
            'The folder with this name already exists'.tr,
            Icon(FontAwesomeIcons.exclamationCircle,
                color: Colors.deepOrangeAccent.shade400),
            false);
      }
    }
  }

  void _buildSnackbar(
      String title, String message, Icon icon, bool isActionSuccessful) {
    return Get.snackbar(
      title,
      message,
      titleText: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
      ),
      messageText: Text(
        message,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      icon: icon,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
      barBlur: 12,
      borderWidth: 2,
      borderColor: isActionSuccessful
          ? Colors.limeAccent.shade700
          : Colors.deepOrangeAccent.shade400,
      snackbarStatus: (status) {
        if (status == SnackbarStatus.OPENING) {
          setState(() {
            textFieldEnabled = false;
          });
        }
        if (status == SnackbarStatus.CLOSED && this.mounted) {
          setState(() {
            textFieldEnabled = true;
          });
        }
      },
    );
  }
}
