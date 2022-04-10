import 'package:flutter/material.dart';
import 'package:deepin/data/data.dart';
import 'package:deepin/src/utils.dart';
import 'package:deepin/widgets/widgets.dart';
import 'package:deepin/models/content_model.dart';


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
    _scrollController = ScrollController();
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
            body: CustomScrollView(
              controller: _scrollController,
              slivers: List.generate(content_list.length, (int index) =>
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