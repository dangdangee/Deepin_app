import 'package:flutter/material.dart';
import 'package:flutter_netflix_responsive_ui/models/content_model.dart';

class DetailScreen extends StatelessWidget {
  final Content? content;
  // _DetailScreenState createState() => _DetailScreenState();

  const DetailScreen({
    @required this.content
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height/20,
        backgroundColor: Colors.black,
        leading: IconButton(
            color: Colors.white,
            onPressed: (){Navigator.pop(context);},
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