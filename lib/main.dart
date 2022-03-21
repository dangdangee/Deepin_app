import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_netflix_responsive_ui/models/content_model.dart';
import 'package:flutter_netflix_responsive_ui/src/authentication.dart';

void main() {
  runApp(MultiProvider(providers:[
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      //builder: (context, _) => MyApp(),
    ),
    ChangeNotifierProvider(
      create: (context) => Content(),
      //builder: (context, _) => MyApp(),
    ),
  ],
  child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Flutter Netflix UI',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.black,
          ),
          home: Consumer<ApplicationState>(
                builder: (context, appState, _) => Authentication(
                email: appState.email,
                loginState: appState.loginState,
                verifyEmail: appState.verifyEmail,
                signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
                cancelRegistration: appState.cancelRegistration,
                registerAccount: appState.registerAccount,
              )
        )
    );
  }
}