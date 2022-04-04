import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_netflix_responsive_ui/cubits/cubits.dart';
import 'package:flutter_netflix_responsive_ui/data/data.dart';
import 'package:flutter_netflix_responsive_ui/widgets/widgets.dart';
import 'package:flutter_netflix_responsive_ui/models/content_model.dart';

class HomeScreen extends StatefulWidget {
  String? topic;
  HomeScreen({
    Key? key,
    @required this.topic,
  }) : super(key:key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController? _scrollController;
  String? _topic;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        context.read<AppBarCubit>().setOffset(_scrollController!.offset);
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _topic = widget.topic;
    final Size screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
      future: get_contentlist('soccer/epl/'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return CircularProgressIndicator();
        }

        else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontSize: 15),
            ),
          );
        }

        else {
          List<Content> content_list = snapshot.data! as List<Content>;
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(screenSize.width, 50.0),
              child: BlocBuilder<AppBarCubit, double>(
                builder: (context, scrollOffset) {
                  return CustomAppBar(scrollOffset: scrollOffset);
                },
              ),
            ),
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                /*SliverToBoxAdapter(
                  child: ContentHeader(featuredContent: sintelContent),
                ),*/
                SliverToBoxAdapter(
                  child: ContentList(
                    key: PageStorageKey(_topic),
                    title: _topic,
                    contentList: content_list,
                  ),
                ),
              ],
            ),
          );
        }
      }
    );
  }
}