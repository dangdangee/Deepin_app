import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_netflix_responsive_ui/src/authentication.dart';
import 'package:flutter_netflix_responsive_ui/screens/screens.dart';
import 'package:flutter_netflix_responsive_ui/models/models.dart';

class ContentList extends StatelessWidget {
  final String? title;
  final List<Content>? contentList;

  const ContentList({
    Key? key,
    @required this.title,
    @required this.contentList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                return Consumer2<Content, ApplicationState>(builder: (context, content_, appState, _) =>
                    GestureDetector(
                    onTap: () {
                      appState.getDisplayName();
                      if(appState.displayName=="Sungtae Lee") { //change "Sungtae Lee" to HOSTNAME
                        print("null3");
                        print(appState.displayName);
                        print("null4");
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (BuildContext context) {
                                  // return DetailScreen(contentList[index]);
                                  return DetailScreen(
                                    content: contentList![index],
                                  );
                                }
                            )
                        );
                        print("null5");
                      } else {
                        print("null6");
                        content_.touch(appState.displayName!, content.name!);
                        print("null7");
                      }
                      },
                    child:Stack(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          height: 200.0,
                          width: 130.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(content.imageUrl!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        content_.touched_users.length > 0?
                        Align(
                          alignment: Alignment.topCenter,
                          child: Icon(Icons.heart_broken_sharp, color:Colors.blue),
                        ) : Align(
                          alignment: Alignment.topCenter,
                          child: Icon(Icons.heart_broken_sharp, color:Colors.red),
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
