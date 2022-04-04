import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_netflix_responsive_ui/data/data.dart';
import 'package:flutter_netflix_responsive_ui/src/utils.dart';
import 'package:flutter_netflix_responsive_ui/cubits/cubits.dart';
import 'package:flutter_netflix_responsive_ui/widgets/widgets.dart';
import 'package:flutter_netflix_responsive_ui/models/content_model.dart';

class DetailScreen extends StatefulWidget {
  final List<Content>? content_list;
  final Content? content;
  final String? sharer;

  DetailScreen({
    Key? key,
    @required this.content_list,
    @required this.content,
    @required this.sharer,
  }) : super(key:key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  ScrollController? _scrollController;
  List<Content>? content_list;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        context.read<AppBarCubit>().setOffset(_scrollController!.offset);
      });
    super.initState();
    this.content_list = content_list;
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.content_list = widget.content_list!.toList();
    this.content_list!.remove(widget.content!);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery
            .of(context)
            .size
            .height / 20,
        backgroundColor: Colors.black,
        leading: IconButton(
            color: Colors.white,
            onPressed: () {
              eraseRoomUserTouch(widget.sharer!);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Icon(Icons.arrow_back)
        ),
      ),
      body: Column(children: [
        (widget.content!.imageUrl!.contains("mp4") ||
        widget.content!.imageUrl!.contains("gif")) ?
        Padding(
          padding: const EdgeInsets
              .symmetric(
              horizontal: 8.0),
          child:StackedVideoView(videoUrl:widget.content!.imageUrl!,
            height:MediaQuery.of(context).size.height*0.5,
            in_detailscreen:true),
        ):
        Container(
          height: MediaQuery.of(context).size.height*0.5,
          width: MediaQuery.of(context).size.width*0.7,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.network(widget.content!.imageUrl!).image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height:10),
        Text(widget.content!.name!.toCapitalized(), style: TextStyle(fontSize:20, color:Colors.white)),
        Expanded(child:CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: ContentList(
                key: PageStorageKey('myList'),
                title: '',
                contentList: this.content_list!,
              ),
            ),
          ],
        )),
      ]),
    );
  }
}