import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:su_kabi/screens/iotscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/iotscreen': (BuildContext context) => IotScreen()
      },
      debugShowCheckedModeBanner: false,
      // lets make it dark themed
      // that looks better
      theme: ThemeData(brightness: Brightness.dark),
      home: IotScreen(),
    );
  }
}
