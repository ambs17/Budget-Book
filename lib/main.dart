
import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'theme/theme.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

void main() async{
  await Hive.initFlutter(); //need hive_flutter.dart for this
  await Hive.openBox('money'); //need hive.dart for opening
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: myTheme,
      home: const Home(),
    );
  }
}

