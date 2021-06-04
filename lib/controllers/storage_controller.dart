import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:links_saved_thanks/models/link_info_model.dart';

class StorageController extends GetxController {
  var storedList = [];
  var allLinks = <LinkInfoModel>[].obs;

  @override
  onInit() {
    if (GetStorage('Data').read('allLinksList') != null) {
      //Read json from storage
      List storedList = GetStorage('Data').read('allLinksList');
      //Convert list of jsons to list of LinkInfoModels
      allLinks = storedList.map((e) => LinkInfoModel.fromJson(e)).toList().obs;
    }
    //Evry time list changes write to storage
    ever(allLinks, (_) {
      GetStorage('Data').write('allLinksList', allLinks.toList());
      //TODO: Check if triggered when property of one model changes
    });
    super.onInit();
  }

  //when close app passing LinkInfoModels to json and save it
  @override
  void onClose() {
    var listToSave = allLinks.map((element) => element.toJson()).toList();
    GetStorage('Data').write('allLinksList', listToSave.toList());
    super.onClose();
  }
}
