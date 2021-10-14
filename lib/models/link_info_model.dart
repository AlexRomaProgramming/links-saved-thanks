import 'dart:convert';

LinkInfoModel linkInfoModelFromJson(String str) =>
    LinkInfoModel.fromJson(json.decode(str));

String linkInfoModelToJson(LinkInfoModel data) => json.encode(data.toJson());

class LinkInfoModel {
  LinkInfoModel({
    this.url = '',
    this.title = '',
    //this.description = '',
    this.image = '',
    required this.folder,
    required this.date,
  });

  String url;
  String title;
  //String description;
  String image;
  List<String> folder = [];
  DateTime date;

  factory LinkInfoModel.fromJson(Map<String, dynamic> json) => LinkInfoModel(
        url: json["url"],
        title: json["title"],
        //description: json["description"],
        image: json["image"],
        folder: List<String>.from(json["folder"].map((x) => x)),
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "title": title,
        //"description": description,
        "image": image,
        "folder": List<dynamic>.from(folder.map((x) => x)),
        "date": date.toIso8601String(),
      };
}
