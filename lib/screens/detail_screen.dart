import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  _DetailScreenState createState() => _DetailScreenState();

  // @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //   throw UnimplementedError();
  // }
  
  
}

class _DetailScreenState extends State<DetailScreen>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
        ),
        child: Row(
          children: [
            ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
        ),]
        ),
      ),
    );
  }
}


