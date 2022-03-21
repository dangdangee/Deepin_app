import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_netflix_responsive_ui/cubits/cubits.dart';
import 'package:flutter_netflix_responsive_ui/data/data.dart';
import 'package:flutter_netflix_responsive_ui/widgets/widgets.dart';
import 'package:flutter_netflix_responsive_ui/assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          children: [
            InkWell(
              onTap: () => {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      // title: new Text("Alert Dialog title"),
                      content: new Text("I'm interested in soccer, music, movie!"),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text("Close"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                )
              },
              child:Container(
                padding: EdgeInsets.all(3),
                width: screenSize.width/3,
                child: Image.asset(Assets.monkey),
              ),
            ),
            InkWell(
              onTap: ()=>{
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      // title: new Text("Alert Dialog title"),
                      content: new Text("I'm interested in NFT, music, dogs!"),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text("Close"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                )
              },
              child:Container(
                padding: EdgeInsets.all(3),
                width: screenSize.width/3,
                child: Image.asset(Assets.monkey),
              ),
            ),
            InkWell(
              onTap: ()=>{
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      // title: new Text("Alert Dialog title"),
                      content: new Text("I'm interested in cats, NBA, MLB!"),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text("Close"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                )
              },
              child:Container(
                padding: EdgeInsets.all(3),
                width: screenSize.width/3,
                child: Image.asset(Assets.monkey),
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: ContentHeader(featuredContent: sintelContent),
          ),
          SliverToBoxAdapter(
            child: ContentList(
              key: PageStorageKey('myList'),
              title: 'My List',
              contentList: myList,
            ),
          ),
          SliverToBoxAdapter(
            child: ContentList(
              key: PageStorageKey('originals'),
              title: 'Netflix Originals',
              contentList: originals,
              // isOriginals: true,
            ),
          ),
          SliverToBoxAdapter(
            child: ContentList(
              key: PageStorageKey('trending'),
              title: 'Trending',
              contentList: trending,
            ),
          ),
        ],
      ),
    );
  }
}