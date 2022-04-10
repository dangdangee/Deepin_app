import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:deepin/assets.dart';
import 'package:deepin/src/utils.dart';
import 'package:deepin/src/authentication.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 24.0,
      ),
      child: Consumer<ApplicationState>(builder: (context, appState, _) =>
        _CustomAppBarMobile(signOut:appState.signOut)),
    );
  }
}

Map<String, IconData> subjectList = {
  'soccer':Icons.sports_soccer_outlined,
  'fashion':Icons.dry_cleaning,
  'music':Icons.music_note_rounded,
  'entertain':Icons.grade,
  'movie&drama': Icons.movie_outlined,
  'game':Icons.videogame_asset,
  'food&restaurant':Icons.dining_outlined,
  'baseball':Icons.sports_baseball_outlined,
  'investment':Icons.attach_money,
};

class _CustomAppBarMobile extends StatelessWidget {
  const _CustomAppBarMobile({
    required this.signOut,
  });
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Image.asset(Assets.deepinLogo),
          SizedBox(width:5),
          Expanded(
              child:ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: subjectList.keys.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                    //color: Colors.white,
                    height: 50,
                    width: 50,
                    child: Center(
                      child: IconButton(
                          padding: EdgeInsets.only(bottom:10),
                          splashRadius: 30,
                          tooltip: subjectList.keys.elementAt(index).toCapitalized(),
                          onPressed: () async {
                            writeSharerTopic(subjectList.keys.elementAt(index));},
                          iconSize: 30,
                          icon: Icon(subjectList.values.elementAt(index)),
                          color: Colors.white,
                      ),
                    ),
                  )
              )
          ),
          IconButton(
              iconSize: 30,
              color: Colors.blue[300],
              padding: EdgeInsets.only(bottom:10),
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: signOut
          ),
        ],
      ),
    );
  }
}

class _AppBarButton extends StatelessWidget {
  final String? title;
  final void Function()? onTap;

  const _AppBarButton({
    Key? key,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}