import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_friendlychat/chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final googleSignIn = new GoogleSignIn();
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("FriendlyChat"),
        elevation:
            Theme.of(context).platform == TargetPlatform.android ? 4.0 : 0.0,
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(4.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          new Divider(
            height: 8.0,
            indent: 8.0,
          ),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textEditingController,
                onSubmitted: _handleSubmitted,
                onChanged: _handleOnTextChanged,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: _buildSendButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    if (Theme.of(context).platform == TargetPlatform.android) {
      return new IconButton(
        icon: new Icon(Icons.send),
        onPressed: _isComposing
            ? () => _handleSubmitted(_textEditingController.text)
            : null,
      );
    } else {
      return new CupertinoButton(
        child: new Text("Send"),
        onPressed: _isComposing
            ? () => _handleSubmitted(_textEditingController.text)
            : null,
      );
    }
  }

  Future<Null> _handleSubmitted(String text) async {
    _textEditingController.clear();
    setState(() {
      _isComposing = false;
    });
    await _ensureLoggedIn();
    _sendMessage(text);
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) user = await googleSignIn.signInSilently();
    if (user == null) {
      await googleSignIn.signIn();
    }
  }

  void _sendMessage(String text) {
    AnimationController animationController = new AnimationController(
      duration: new Duration(milliseconds: 700),
      vsync: this,
    );
    animationController.addStatusListener(_handleAnimationStatus);
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: animationController,
    );
    setState(() {
      _messages.insert(0, message);
    });
    animationController.forward();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      print("Messaged Added!");
    }
  }

  void _handleOnTextChanged(String text) {
    setState(() {
      _isComposing = text.length > 0;
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
