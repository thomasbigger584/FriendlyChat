import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
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

  void _handleSubmitted(String text) {
    _textEditingController.clear();
    setState(() {
      _isComposing = false;
    });
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

const String _name = "Thomas Bigger";

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});

  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.fastOutSlowIn),
      child: new FadeTransition(
        opacity: _buildOpacityAnimation(),
        child: new Card(
          child: new Container(
            margin: const EdgeInsets.all(8.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: new InkWell(
                    child: new CircleAvatar(
                      child: new Text(_name[0]),
                    ),
                    onTap: _handleAvatarPress,
                    onLongPress: _handleAvatarLongPress,
                  ),
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(_name,
                          style: Theme.of(context).textTheme.subhead),
                      new Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: new Text(text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Animation<double> _buildOpacityAnimation() {
    return new Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(animationController);
  }

  void _handleAvatarPress() {
    print("Avatar press");
  }

  void _handleAvatarLongPress() {
    print("Avatar long press");
  }
}
