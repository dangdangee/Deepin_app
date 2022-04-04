import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_netflix_responsive_ui/src/utils.dart';
import 'package:flutter_netflix_responsive_ui/data/data.dart';
import 'package:flutter_netflix_responsive_ui/cubits/cubits.dart';
import 'package:flutter_netflix_responsive_ui/widgets/widgets.dart';
import 'package:flutter_netflix_responsive_ui/models/content_model.dart';

class DetailScreen extends StatefulWidget {
  final Content? content;
  final String? sharer;

  DetailScreen({
    Key? key,
    @required this.content,
    @required this.sharer,
  }) : super(key:key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  ScrollController? _scrollController;

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
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)
        ),
      ),
      body: Column(children: [
        Container(
          height: MediaQuery.of(context).size.height*0.5,
          width: MediaQuery.of(context).size.width*0.5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.content!.imageUrl!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text("wow", style: TextStyle(fontSize:20, color:Colors.white)),
        Expanded(child:CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: ContentList(
                key: PageStorageKey('myList'),
                title: '',
                contentList: myList,
              ),
            ),
          ],
        )),
      ]),
    );
  }
}

/*
Scaffold(
            extendBodyBehindAppBar: false,
            bottomNavigationBar: BottomAppBar(
              color: Colors.black,
              child: Row(
                children: [
                  InkWell(
                    onTap: () =>
                    {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            // title: new Text("Alert Dialog title"),
                            content: Wrap(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Image.asset(Assets.profile1),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                      "I'm interested in soccer, music, movie!"),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Close"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      )
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
                      width: screenSize.width / 3,
                      child: Image.asset(Assets.profile1),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                    {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            // title: new Text("Alert Dialog title"),
                            content: Wrap(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Image.asset(Assets.profile2),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                      "I'm interested in soccer, music, movie!"),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Close"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      )
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
                      width: screenSize.width / 3,
                      child: Image.asset(Assets.profile2),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                    {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            // title: new Text("Alert Dialog title"),
                            content: Wrap(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Image.asset(Assets.profile3),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                      "I'm interested in soccer, music, movie!"),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Close"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      )
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
                      width: screenSize.width / 3,
                      child: Image.asset(Assets.profile3),
                    ),
                  ),
                ],
              ),
            ),
            appBar: PreferredSize(
              preferredSize: Size(screenSize.width, 50.0),
              child: BlocBuilder<AppBarCubit, double>(
                builder: (context, scrollOffset) {
                  return CustomAppBar(scrollOffset: scrollOffset);
                },
              ),
            ),
 */