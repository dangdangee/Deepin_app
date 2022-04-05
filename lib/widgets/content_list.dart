import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:deepin/assets.dart';
import 'package:deepin/models/models.dart';
import 'package:deepin/screens/screens.dart';
import 'package:deepin/src/utils.dart';
import 'package:deepin/src/authentication.dart';

import '../data/data.dart';


class ContentList extends StatelessWidget {
  final String? title;
  final List<Content>? contentList;
  List<String>? contentnameList;

  ContentList({
    Key? key,
    @required this.title,
    @required this.contentList,
    this.contentnameList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.contentList != null) {
      this.contentList!.forEach((content) {
        if (this.contentnameList != null) {
          this.contentnameList!.add(content.parent_name!+"/"+content.name!);
        } else {
          this.contentnameList = [content.parent_name!+"/"+content.name!];
        }
      });
    }
    return FutureBuilder(
        future: readViewerUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot_) {
          if (snapshot_.hasData == false) {
            return const Center(child:CircularProgressIndicator());
          }

          else if (snapshot_.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot_.error}',
                style: TextStyle(fontSize: 15),
              ),
            );
          }

          else {
            List<String> viewerUsers = snapshot_.data! as List<String>;
            return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('rooms').doc('0').collection('users').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    final Map<String, List<String>> touched_items = {};
                    String sharer_item='';
                    String sharer='';
                    if (snapshot.hasData) {
                      snapshot.data!.docs.forEach((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<
                            String,
                            dynamic>;
                        if (data['role']=='Sharer') {
                          sharer = document.id;
                        }
                        if (data['role']=='Viewer' &&
                            data.keys.contains('touch')) {
                          if (touched_items.keys.contains(data['touch'])) {
                            if (!touched_items[data['touch']]!.contains(document
                                .id)) {
                              touched_items[data['touch']]!.add(document.id);
                            }
                          } else {
                            touched_items[data['touch']] = [document.id];
                          }
                        }
                        else if (data['role']=='Sharer' &&
                            data.keys.contains('touch')) {
                          sharer_item = data['touch'];
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            if (contentnameList!.contains(sharer_item)) {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (BuildContext context) =>
                                          DetailScreen(
                                            content_list: contentList!,
                                            content: contentList![contentnameList!
                                                .indexOf(sharer_item)],
                                            sharer: sharer,
                                          )
                                  )
                              );
                            }
                          });
                        }
                      });
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0),
                            child: Text(
                              title!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            height: 220.0,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: contentList!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final Content content = contentList![index];
                                return Consumer<ApplicationState>(
                                    builder: (context, appState, _) =>
                                        GestureDetector(
                                            onTap: () async {
                                              content.touch(
                                                  appState.displayName!,
                                                  touched_items[content.parent_name!+"/"+content.name!]
                                                      ?.contains(
                                                      appState.displayName!));
                                            },
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  height: 200.0,
                                                  width: 130.0,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: Image.network(content.imageUrl!).image,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Align(
                                                      alignment: Alignment
                                                          .topCenter,
                                                      child: (touched_items
                                                          .keys
                                                          .contains(
                                                          content.parent_name!+"/"+content.name!)) ?
                                                      Row(children: [
                                                        (touched_items[content.parent_name!+"/"+content.name!]!.contains(
                                                            viewerUsers
                                                                .elementAt(
                                                                0)))
                                                            ?
                                                        Image(
                                                            image: AssetImage(
                                                                Assets
                                                                    .pikachu),
                                                            height: 50.0,
                                                            width: 50.0)
                                                            : SizedBox
                                                            .shrink(),
                                                        (viewerUsers.length ==
                                                            2 &&
                                                            touched_items[content.parent_name!+"/"+content.name!]!
                                                                .contains(
                                                                viewerUsers
                                                                    .elementAt(
                                                                    1)))
                                                            ?
                                                        Image(
                                                            image: AssetImage(
                                                                Assets
                                                                    .squirtle),
                                                            height: 50.0,
                                                            width: 50.0)
                                                            : SizedBox
                                                            .shrink(),
                                                      ]) :
                                                      null
                                                  ),
                                                ),
                                              ],
                                            )
                                        )
                                );
                              },
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
    );
  }
}