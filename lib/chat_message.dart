import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
