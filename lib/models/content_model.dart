import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Content extends ChangeNotifier {
  final String? name;
  final String? imageUrl;
  final String? titleImageUrl;
  final String? videoUrl;
  final String? description;
  final Color? color;
  final List<String> touched_users=[];

  Content({
    @required this.name,
    @required this.imageUrl,
    this.titleImageUrl,
    this.videoUrl,
    this.description,
    this.color,
  });

  void touch(String user_id, String content_name) {
    print(user_id);
    print(content_name);
    touched_users.add(user_id);
    notifyListeners();
  }

  void clear(String user_id) {
    touched_users.remove(user_id);
    notifyListeners();
  }
}