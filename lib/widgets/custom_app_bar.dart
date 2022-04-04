import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_netflix_responsive_ui/assets.dart';
import 'package:flutter_netflix_responsive_ui/widgets/widgets.dart';
import 'package:flutter_netflix_responsive_ui/src/utils.dart';
import 'package:flutter_netflix_responsive_ui/src/authentication.dart';

class CustomAppBar extends StatelessWidget {
  final double scrollOffset;

  const CustomAppBar({
    Key? key,
    this.scrollOffset = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 24.0,
      ),
      color:
        Colors.black.withOpacity((scrollOffset / 350).clamp(0, 1).toDouble()),
      child: Responsive(
        mobile: Consumer<ApplicationState>(builder: (context, appState, _) =>
                _CustomAppBarMobile(signOut:appState.signOut)),
        desktop: Consumer<ApplicationState>(builder: (context, appState, _) =>
            _CustomAppBarDesktop(signOut:appState.signOut)),
      ),
    );
  }
}

const IconData shirt = IconData(0xe82c, fontFamily: "customappbar", fontPackage: null);

Map<String, IconData> subjectList = {
  'soccer':Icons.sports_soccer_outlined,
  'Fashion':Icons.dry_cleaning,
  'Music':Icons.music_note_rounded,
  'entertain':Icons.grade,
  'Movie/Drama': Icons.movie_outlined,
  'Game':Icons.videogame_asset,
  'Food/Restaurant':Icons.dining_outlined,
  'Baseball':Icons.sports_baseball_outlined,
  'Investment':Icons.attach_money,
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

class _CustomAppBarDesktop extends StatelessWidget {
  const _CustomAppBarDesktop({
    required this.signOut,
  });
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Image.asset(Assets.netflixLogo1),
          const SizedBox(width: 12.0),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AppBarButton(
                  title: 'Home',
                  onTap: () => print('Home'),
                ),
                _AppBarButton(
                  title: 'TV Shows',
                  onTap: () => print('TV Shows'),
                ),
                _AppBarButton(
                  title: 'Movies',
                  onTap: () => print('Movies'),
                ),
                _AppBarButton(
                  title: 'Latest',
                  onTap: () => print('Latest'),
                ),
                _AppBarButton(
                  title: 'My List',
                  onTap: () => print('My List'),
                ),
              ],
            ),
          ),
          const Spacer(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.search),
                  iconSize: 28.0,
                  color: Colors.white,
                  onPressed: () => print('Search'),
                ),
                _AppBarButton(
                  title: 'KIDS',
                  onTap: () => print('KIDS'),
                ),
                _AppBarButton(
                  title: 'DVD',
                  onTap: () => print('DVD'),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.card_giftcard),
                  iconSize: 28.0,
                  color: Colors.white,
                  onPressed: () => print('Gift'),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.notifications),
                  iconSize: 28.0,
                  color: Colors.white,
                  onPressed: () => print('Notifications'),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
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