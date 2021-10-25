import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:links_saved_thanks/models/link_info_model.dart';

class StorageController extends GetxController {
  var storedList = []; // auxiliar list, filled from memory storage
  var allLinks = <LinkInfoModel>[].obs; //main list of all links
  var bottomBarIndex = 0.obs; //which bottom bar item is activated
  var folderList = <String>[].obs; //list of all existing folders
  var searchHistoryList = <String>[].obs; //search history list
  var isFromOutside = true.obs; //if app begins with cardPage or with menuPage
  var newFolderName = ''.obs; //name of ricent created folder, -> animated list
  var isInternetConnected = true.obs; //for check the internet connection

  @override
  onInit() {
    //Read json from storage
    storedList = GetStorage('Data').read('allLinksList') ?? <LinkInfoModel>[];
    //Convert list of jsons to list of LinkInfoModels
    allLinks = storedList.map((e) => LinkInfoModel.fromJson(e)).toList().obs;

    //read list of folders from storage and pass it to RxList
    var folderListAux =
        GetStorage('Data').read('allFolders') ?? <String>['Default'];
    folderList = new RxList.from(folderListAux);

    //read search history list from storage and pass it to RxList
    var searchHistoryListAux =
        GetStorage('Data').read('historyList') ?? <String>[];
    searchHistoryList = new RxList.from(searchHistoryListAux);

    //Evry time list changes write to storage
    ever(allLinks, (_) {
      GetStorage('Data').write('allLinksList', allLinks.toList());
    });
    //Every time list changes rewrite in storage
    ever(folderList, (_) {
      GetStorage('Data').write('allFolders', folderList);
    });
    //Every time history updated rewrite it
    ever(searchHistoryList, (_) {
      GetStorage('Data').write('historyList', searchHistoryList);
    });
    super.onInit();
  }

  //checking if link no exist in allLinks list, if exists return the position
  int positionIfUrlExists(String urlForChecking) {
    int position = -1;
    allLinks.forEach((element) {
      if (element.url == urlForChecking) position = allLinks.indexOf(element);
    });
    return position;
  }

  //with this method we can rewrite link list when property of one of elements changes
  void recordLinkList(RxList list) {
    GetStorage('Data').write('allLinksList', list.toList());
  }

  //when close app passing LinkInfoModels to json and save it
  @override
  void onClose() {
    var listToSave = allLinks.map((element) => element.toJson()).toList();
    GetStorage('Data').write('allLinksList', listToSave.toList());

    super.onClose();
  }
  //TODO: create layout for big screen
  //TODO: check the language change with resumed app
}
