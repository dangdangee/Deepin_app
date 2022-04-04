import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter_netflix_responsive_ui/assets.dart';
import 'package:flutter_netflix_responsive_ui/models/models.dart';

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
  result.prefixes.forEach((firebase_storage.Reference ref) {
    dirlist.add(ref.name);
  });
  return dirlist;
}

Future<List<dynamic>> listFile(firebase_storage.FirebaseStorage storage, String dirname) async {
  firebase_storage.ListResult result = await storage.ref(dirname).listAll();
  List<String> filelist = [];
  Map<String, String> file2url = {};
  await Future.forEach(result.items, (firebase_storage.Reference ref) async {
    filelist.add(ref.name);
    file2url[ref.name] = await ref.getDownloadURL();
  });
  return [filelist, file2url];
}

Future<List<dynamic>> get_contentlist(String dirname) async { // 'entertain'
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  List<String> directorylists = await listDirectory(storage, dirname+"/");
  List<List<String>> filelists = [];
  List<Map<String,String>> file2urls = [];
  await Future.forEach(directorylists, (directory) async {
    var listfile_output = await listFile(storage, dirname+"/${directory}");
    List<String> tmp_filelists = listfile_output[0];
    Map<String, String> file2url = listfile_output[1];
    filelists.add(tmp_filelists);
    file2urls.add(file2url);
  });

  return [List.generate(filelists.length, (int index1) => List.generate(filelists[index1].length, (int index2) =>
    Content(
      name: filelists[index1][index2].split('.')[0],
      imageUrl: file2urls[index1][filelists[index1][index2]],
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
  final bool? in_detailscreen;

  StackedVideoView({
    Key? key,
    @required this.videoUrl,
    @required this.height,
    @required this.in_detailscreen,
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
        double height = 200; //this.height!; //model.videoPlayerController!.value.size.height;
        double width = height*model.videoPlayerController!.value.size.aspectRatio;
        return isInitialized ?
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            height: height,
            width: width,
            child: GestureDetector(
                onTap: () =>
                in_detailscreen! ? (isPlaying ? model.pauseVideo() : model.playVideo()):null,
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