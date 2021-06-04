import 'dart:convert';

LinkInfoModel linkInfoModelFromJson(String str) =>
    LinkInfoModel.fromJson(json.decode(str));

String linkInfoModelToJson(LinkInfoModel data) => json.encode(data.toJson());

class LinkInfoModel {
  final String title, description, image, url;
  DateTime date;
  String folder;

  LinkInfoModel(
      {this.title = '',
      this.description = '',
      this.image = '',
      this.url = '',
      this.folder = 'default',
      required this.date});

  factory LinkInfoModel.fromJson(Map<String, dynamic> json) => LinkInfoModel(
        url: json["url"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        folder: json["folder"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "title": title,
        "description": description,
        "image": image,
        "folder": folder,
        "date": date.toIso8601String(),
      };
}
