import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_netflix_responsive_ui/assets.dart';
import 'package:flutter_netflix_responsive_ui/models/models.dart';

final Content sintelContent = Content(
  name: 'Sintel',
  imageUrl: Assets.sintel,
  titleImageUrl: Assets.sintelTitle,
  videoUrl: Assets.sintelVideoUrl,
  description:
      'A lonely young woman, Sintel, helps and befriends a dragon,\nwhom she calls Scales. But when he is kidnapped by an adult\ndragon, Sintel decides to embark on a dangerous quest to find\nher lost friend Scales.',
);

final List<Content> myList = [
  Content(name: 'Violet Evergarden', imageUrl: Assets.violetEvergarden),
  Content(name: 'How to Sell Drugs Online (Fast)', imageUrl: Assets.htsdof),
  Content(name: 'Kakegurui', imageUrl: Assets.kakegurui),
  Content(name: 'Carole and Tuesday', imageUrl: Assets.caroleAndTuesday),
  Content(name: 'Black Mirror', imageUrl: Assets.blackMirror),
  Content(name: 'Violet Evergarden', imageUrl: Assets.violetEvergarden),
  Content(name: 'How to Sell Drugs Online (Fast)', imageUrl: Assets.htsdof),
  Content(name: 'Kakegurui', imageUrl: Assets.kakegurui),
  Content(name: 'Carole and Tuesday', imageUrl: Assets.caroleAndTuesday),
  Content(name: 'Black Mirror', imageUrl: Assets.blackMirror),
];

final List<Content> originals = [
  Content(name: 'Stranger Things', imageUrl: Assets.strangerThings),
  Content(name: 'The Witcher', imageUrl: Assets.witcher),
  Content(name: 'The Umbrella Academy', imageUrl: Assets.umbrellaAcademy),
  Content(name: '13 Reasons Why', imageUrl: Assets.thirteenReasonsWhy),
  Content(name: 'The End of the F***ing World', imageUrl: Assets.teotfw),
  Content(name: 'Stranger Things', imageUrl: Assets.strangerThings),
  Content(name: 'The Witcher', imageUrl: Assets.witcher),
  Content(name: 'The Umbrella Academy', imageUrl: Assets.umbrellaAcademy),
  Content(name: '13 Reasons Why', imageUrl: Assets.thirteenReasonsWhy),
  Content(name: 'The End of the F***ing World', imageUrl: Assets.teotfw),
];

final List<Content> trending = [
  Content(name: 'Explained', imageUrl: Assets.explained),
  Content(name: 'Avatar The Last Airbender', imageUrl: Assets.atla),
  Content(name: 'Tiger King', imageUrl: Assets.tigerKing),
  Content(name: 'The Crown', imageUrl: Assets.crown),
  Content(name: 'Dogs', imageUrl: Assets.dogs),
  Content(name: 'Explained', imageUrl: Assets.explained),
  Content(name: 'Avatar The Last Airbender', imageUrl: Assets.atla),
  Content(name: 'Tiger King', imageUrl: Assets.tigerKing),
  Content(name: 'The Crown', imageUrl: Assets.crown),
  Content(name: 'Dogs', imageUrl: Assets.dogs),
];

Future<List<FileSystemEntity>> dirContents(Directory dir) {
  var files = <FileSystemEntity>[];
  var completer = Completer<List<FileSystemEntity>>();
  var lister = dir.list(recursive: false);
  lister.listen (
          (file) => files.add(file),
      // should also register onError
      onDone:   () => completer.complete(files)
  );
  return completer.future;
}

Future<List<String>> get_filenames(String dirname) async {
  List<String> filenames = [];
  String rootpath = '/Users/sungtaelee/StudioProjects/flutter_netflix_responsive_ui/';
  List<FileSystemEntity> entities = await dirContents(Directory(rootpath+'assets/images/'+dirname));
  entities.forEach((entity) => filenames.add(entity.path.split("/").last));
  print(filenames);
  return filenames;
}

Future<List<Content>> get_contentlist(String dirname) async { // 'entertain'
  List<String> filenames  = await get_filenames(dirname);
  return List.generate(filenames.length, (int index) =>
      Content(name: filenames.elementAt(index).split('.')[0],
      imageUrl: 'assets/images/'+dirname+filenames.elementAt(index)), growable:false);
}