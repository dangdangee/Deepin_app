import 'package:flutter/material.dart';
import 'package:flutter_netflix_responsive_ui/src/utils.dart';

class Content {
  final String? name;
  final String? imageUrl;
  final String? parent_name;
  final String? titleImageUrl;
  final String? videoUrl;
  final String? description;
  final Color? color;

  Content({
    @required this.name,
    @required this.imageUrl,
    @required this.parent_name,
    this.titleImageUrl,
    this.videoUrl,
    this.description,
    this.color,
  });

  void touch(String displayName, bool? exists) {
    if (exists == true) {
      eraseRoomUserTouch(displayName);
    } else {
      writeRoomUserTouch(displayName, this.name!);
    }
  }
}