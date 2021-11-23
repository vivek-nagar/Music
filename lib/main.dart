import 'package:flutter/material.dart';
import 'package:music/InitialMusc.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music',
      home: MusicList(),
    );
  }
}
