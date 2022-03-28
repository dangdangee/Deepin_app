import 'package:flutter/material.dart';
import 'package:flutter_netflix_responsive_ui/src/utils.dart';
import 'package:flutter_netflix_responsive_ui/models/content_model.dart';

class DetailScreen extends StatelessWidget {
  final Content? content;
  final String? sharer;
  // _DetailScreenState createState() => _DetailScreenState();

  const DetailScreen({
    @required this.content,
    @required this.sharer
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height/20,
        backgroundColor: Colors.black,
        leading: IconButton(
            color: Colors.white,
            onPressed: (){
              eraseRoomUserTouch(this.sharer!);
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(content!.imageUrl!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }}