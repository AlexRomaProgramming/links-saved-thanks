import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'package:links_saved_thanks/controllers/storage_controller.dart';
import 'package:links_saved_thanks/models/link_info_model.dart';

//Request to url for title, description, image url data
Future<LinkInfoModel> fetchLinkInfo(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final document = parse(response.body);
    return _createLinkObjectFromDocument(document, url);
  } else {
    return LinkInfoModel(date: DateTime.now(), folder: [], image: 'no_image');
  }
}

//Generate a model object (LinkInfoModel) from document (html)
LinkInfoModel _createLinkObjectFromDocument(Document document, String linkUrl) {
  //all elements with 'meta' tag
  final metaElements = document.getElementsByTagName('meta');

  var title, image;

  //
  metaElements.forEach((element) {
    if (element.attributes['property'] == 'og:title') {
      //fetch title from og
      title = element.attributes['content'];
    }

    // //fetch description from og
    // if (element.attributes['property'] == 'og:description') {
    //   description = element.attributes['content'];
    // }
    // //if description from og is empty then fetch normal description.
    // if (description == null || description.isEmpty) {
    //   //fetch base title
    //   if (element.attributes['name'] == 'description') {
    //     description = element.attributes['content'];
    //   }
    // }

    //fetch image
    if (element.attributes['property'] == 'og:image') {
      if (_isUrl(element.attributes['content']))
        image = element.attributes['content'];
    }
  });

  //if title from og is empty then fetch normal title
  if (title == null || title.isEmpty) {
    title = document.getElementsByTagName('title')[0].text;
  }

  //it works in Amazon for fetch image
  if (image == null) {
    //all elements with 'img' tag
    final imgElements = document.getElementsByTagName('img');
    //search for 'img' with 'id="landingImage"', attribute 'src' contains image url
    imgElements.forEach((element) {
      if (element.attributes['id'] == 'landingImage') {
        if (_isUrl(element.attributes['src']))
          image = element.attributes['src'];
      }
    });
  }

  //it works in Mil Anuncios for fetch image (sometimes)
  if (image == null) {
    //all elements with tag 'link'
    final linkElements = document.getElementsByTagName('link');
    linkElements.forEach((element) {
      if (element.attributes['rel'] == 'image_src' && image == null) {
        if (_isUrl(element.attributes['href']))
          image = element.attributes['href'];
      }
    });
  }

  //all data in one object
  final linkInfoModel = LinkInfoModel(
      url: linkUrl,
      date: DateTime.now(),
      title: title ?? '',
      //description: description ?? '',
      image: image ?? 'no_image',
      folder: []);

  return linkInfoModel;
}

//check if url starts with 'http://' o 'https://'
bool _isUrl(String? url) {
  if (url!.startsWith('http://') || url.startsWith('https://')) {
    return true;
  } else {
    return false;
  }
}

//return image or  default image
Widget imageToShow(String imageUrl, StorageController storageController) {
  Widget image;
  try {
    if (!storageController.isInternetConnected.value) {
      image = Image.asset('assets/img/no-image.png',
          width: double.infinity,
          //height: 250,
          fit: BoxFit.cover);
    } else if (imageUrl.toLowerCase().endsWith('.svg') && _isUrl(imageUrl)) {
      image = SvgPicture.network(
        imageUrl,
        height: double.infinity,
        width: double.infinity,
        placeholderBuilder: (context) => Image.asset(
          'assets/img/giphy.gif',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else if (_isUrl(imageUrl)) {
      image = FadeInImage.assetNetwork(
          height: double.infinity,
          fit: BoxFit.cover,
          placeholder: 'assets/img/giphy.gif',
          image: imageUrl);
    } else {
      image = Image.asset('assets/img/no-image.png',
          width: double.infinity,
          //height: 250,
          fit: BoxFit.cover);
    }
  } catch (_) {
    image = Image.asset('assets/img/no-image.png',
        width: double.infinity,
        //height: 250,
        fit: BoxFit.cover);
  }
  return image;
}
