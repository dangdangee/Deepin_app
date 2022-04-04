import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_netflix_responsive_ui/cubits/cubits.dart';
import 'package:flutter_netflix_responsive_ui/screens/screens.dart';
import 'package:flutter_netflix_responsive_ui/widgets/custom_app_bar.dart';
import 'package:flutter_netflix_responsive_ui/assets.dart';


class NavScreen extends StatefulWidget {
  int? currentIndex;
  NavScreen({
    Key? key,
    @required this.currentIndex,
  }) : super(key: key);
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final List<Widget> _screens =
  [for(var topic in subjectList.keys.toList() )
    HomeScreen(key: PageStorageKey('homeScreen'),
        topic: topic),];

  int? _currentIndex;

  @override
  Widget build(BuildContext context) {
    _currentIndex = widget.currentIndex;
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: false,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          children: [
            Profile(context, screenSize, 1),
            Profile(context, screenSize, 2),
            Profile(context, screenSize, 3),
          ],
        ),
      ),
      body: BlocProvider<AppBarCubit>(
        create: (_) => AppBarCubit(),
        child: _screens[_currentIndex!],
      ),
    );
  }
}


Widget Profile (BuildContext context, Size screenSize, double index) {
  String profile_url;
  if (index == 1) {
    profile_url = Assets.profile1;
  }
  else if (index == 2) {
    profile_url = Assets.profile2;
  }
  else if (index == 3) {
    profile_url = Assets.profile3;
  }
  else {
    throw Exception("User Index should be among [1,2,3]");
  }
  return InkWell(
    onTap: () =>
    {showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset(profile_url),
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
    )},
    child: Container(
      padding: EdgeInsets.all(3),
      width: screenSize.width / 3,
      child: Image.asset(profile_url),
    ),
  );
}