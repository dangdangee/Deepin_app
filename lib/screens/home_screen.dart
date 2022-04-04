import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_netflix_responsive_ui/data/data.dart';
import 'package:flutter_netflix_responsive_ui/src/utils.dart';
import 'package:flutter_netflix_responsive_ui/cubits/cubits.dart';
import 'package:flutter_netflix_responsive_ui/widgets/widgets.dart';
import 'package:flutter_netflix_responsive_ui/models/content_model.dart';

import '../main.dart';

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
      future: get_contentlist(_topic!),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return const Center(child:CircularProgressIndicator());
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
          var content_list_and_names = snapshot.data!;
          List<List<Content>> content_list = content_list_and_names[0] as List<List<Content>>;
          List<String> dirnames = content_list_and_names[1] as List<String>;
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
              slivers:
              List.generate(content_list.length, (int index) =>
                SliverToBoxAdapter(
                  child: ContentList(
                    key: PageStorageKey(dirnames[index].toCapitalized()),
                    title: dirnames[index].toCapitalized(),
                    contentList: content_list[index],
                  ),
                ),
              ),
            ),
          );
        }
      }
    );
  }
}