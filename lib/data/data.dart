import 'package:intl/intl.dart';

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:deepin/assets.dart';
import 'package:deepin/models/models.dart';

final Content sintelContent = Content(
  name: 'Sintel',
  imageUrl: Assets.sintel,
  parent_name: 'wow',
  titleImageUrl: Assets.sintelTitle,
  videoUrl: Assets.sintelVideoUrl,
  description:
      'A lonely young woman, Sintel, helps and befriends a dragon,\nwhom she calls Scales. But when he is kidnapped by an adult\ndragon, Sintel decides to embark on a dangerous quest to find\nher lost friend Scales.',
);

Future<List<String>> listDirectory(firebase_storage.FirebaseStorage storage, String dirname) async {
  firebase_storage.ListResult result = await storage.ref(dirname).listAll();
  List<String> dirlist = [];
  result.prefixes.forEach((firebase_storage.Reference ref) async {
    dirlist.add(ref.name);
  });
  return dirlist;
}

Future<List<dynamic>> listFile(firebase_storage.FirebaseStorage storage, String dirname) async {
  firebase_storage.ListResult result = await storage.ref(dirname).listAll(); // 오래걸림
  List<String> filelist = [];
  List<Future<String>> urllist = [];
  Map<String, String> file2url = {};
  result.items.forEach((firebase_storage.Reference ref) {
    filelist.add(ref.name);
    urllist.add(ref.getDownloadURL()); // 개오래걸림
  });
  await Future.forEach(filelist.asMap().entries, (MapEntry entry) async {
    file2url[entry.value] = await urllist[entry.key];
  });
  return [filelist, file2url];
}

Future<List<dynamic>> listDirFile(firebase_storage.FirebaseStorage storage, String dirname) async {
  List<List<String>> filelists = [];
  List<Map<String,String>> file2urls = [];
  List<Map<String,String>> file2thumbnails = [];
  List<String> directorylists = [];

  firebase_storage.ListResult result = await storage.ref(dirname).listAll();
  await Future.forEach(result.prefixes, (firebase_storage.Reference ref) async {
    directorylists.add(ref.name);

    firebase_storage.ListResult dirresult = await ref.listAll();

    List<String> filelist = [];
    List<Future<String>> urllist = [];
    Map<String, String> file2url = {};
    Map<String,String> file2thumbnail = {};

    dirresult.items.forEach((firebase_storage.Reference dirref) async {
      filelist.add(dirref.name);
      urllist.add(dirref.getDownloadURL()); // 개오래걸림
    });
    await Future.forEach(filelist.asMap().entries, (MapEntry entry) async {
      file2url[entry.value] = await urllist[entry.key];
    });

    filelists.add(filelist);
    file2urls.add(file2url);
    file2thumbnails.add(file2thumbnail);
  });
  return [filelists, file2urls, file2thumbnails, directorylists];
}

Future<List<dynamic>> new_get_contentlist(String dirname) async { // 'entertain'
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  var dirfilelists = await listDirFile(storage, dirname+"/");
  List<List<String>> filelists = dirfilelists[0];
  List<Map<String,String>> file2urls = dirfilelists[1];
  List<Map<String,String>> file2thumbnails = dirfilelists[2];
  List<String> directorylists = dirfilelists[3];
  return [List.generate(filelists.length, (int index1) => List.generate(filelists[index1].length, (int index2) =>
      Content(
        name: filelists[index1][index2].split('.')[0],
        imageUrl: file2thumbnails[index1].keys.contains(filelists[index1][index2]) ?
        file2thumbnails[index1][filelists[index1][index2]]:file2urls[index1][filelists[index1][index2]],
        videoUrl: file2thumbnails[index1].keys.contains(filelists[index1][index2]) ?
        file2urls[index1][filelists[index1][index2]]:null,
        parent_name: directorylists[index1],
      ),
      growable:false)), directorylists];
}



Future<List<dynamic>> get_contentlist(String dirname) async { // 'entertain'
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  List<String> directorylists = await listDirectory(storage, dirname+"/");
  List<List<String>> filelists = [];
  List<Map<String,String>> file2urls = [];
  List<Map<String,String>> file2thumbnails = [];
  await Future.forEach(directorylists, (directory) async {
    var file_url = await listFile(storage, dirname+"/${directory}");
    List<String> tmp_filelists = file_url[0];
    Map<String, String> tmp_file2urls = file_url[1];
    var thumbnail_url = await listFile(storage, dirname+"/${directory}/thumbnail");
    List<String> tmp_thumbnaillists = thumbnail_url[0];
    Map<String, String> tmp_thumbnail2urls = thumbnail_url[1];
    Map<String, String> tmp_file2thumbnails = {};
    await Future.forEach(tmp_filelists, (String file) async {
      if (file.contains("mp4") || file.contains("gif")) {
        String tmp_thumbnail = tmp_thumbnaillists.singleWhere((element) => element.contains(file.split(".")[0]));
        tmp_file2thumbnails[file] = tmp_thumbnail2urls[tmp_thumbnail]!;
      }
    });
    filelists.add(tmp_filelists);
    file2urls.add(tmp_file2urls);
    file2thumbnails.add(tmp_file2thumbnails);
  });
  return [List.generate(filelists.length, (int index1) => List.generate(filelists[index1].length, (int index2) =>
    Content(
      name: filelists[index1][index2].split('.')[0],
      imageUrl: file2thumbnails[index1].keys.contains(filelists[index1][index2]) ?
      file2thumbnails[index1][filelists[index1][index2]]:file2urls[index1][filelists[index1][index2]],
      videoUrl: file2thumbnails[index1].keys.contains(filelists[index1][index2]) ?
      file2urls[index1][filelists[index1][index2]]:null,
      parent_name: directorylists[index1],
    ),
    growable:false)), directorylists];
}

class StackedVideoViewModel extends BaseViewModel {
  VideoPlayerController? videoPlayerController;

  void initialize(String videoUrl) {
    videoPlayerController = VideoPlayerController.network(videoUrl);
    videoPlayerController!.initialize().then((value) {
      videoPlayerController!.setLooping(true);
      videoPlayerController!.play();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    super.dispose();
  }

  void playVideo(){
    videoPlayerController!.play();
    notifyListeners();
  }

  void pauseVideo(){
    videoPlayerController!.pause();
    notifyListeners();
  }
}

class StackedVideoView extends StatelessWidget {
  final String? videoUrl;
  final double? height;

  StackedVideoView({
    Key? key,
    @required this.videoUrl,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StackedVideoViewModel>.reactive(
      viewModelBuilder: () => StackedVideoViewModel(),
      onModelReady: (model) {
        model.initialize(this.videoUrl!);
      },
      builder: (context, model, child) {
        bool isInitialized = model.videoPlayerController!.value.isInitialized;
        bool isPlaying = model.videoPlayerController!.value.isPlaying;
        double height = this.height!;
        double width = height*model.videoPlayerController!.value.size.aspectRatio;
        return isInitialized ?
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            height: height,
            width: width,
            child: GestureDetector(
                onTap: () =>
                isPlaying ? model.pauseVideo() : model.playVideo(),
                child: VideoPlayer(model.videoPlayerController!),
              )
          )
        ):
        Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}