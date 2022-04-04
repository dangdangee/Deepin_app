import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_netflix_responsive_ui/src/authentication.dart';

void main() {
  runApp(MultiProvider(providers:[
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
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
                signInWithEmailAndPasswordAndRole: appState.signInWithEmailAndPasswordAndRole,
                cancelRegistration: appState.cancelRegistration,
                registerAccount: appState.registerAccount,
              )
        )
    );
  }
}