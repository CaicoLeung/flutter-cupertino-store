
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'tabbar.dart' show TabbarPage;

class CupertinoStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('zh'),
      theme: CupertinoThemeData(primaryColor: CupertinoColors.black),
      home: TabbarPage(),
    );
  }
}