import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_friendlychat/chat_screen.dart';

void main() {
  runApp(new FriendlyChatApp());
}

final ThemeData kIOSTheme = new ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

class FriendlyChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = kDefaultTheme;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      theme = kIOSTheme;
    }
    return new MaterialApp(
      title: "FriendlyChat",
      home: new ChatScreen(),
      theme: theme,
      debugShowCheckedModeBanner: false,
    );
  }
}
