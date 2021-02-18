import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'package:intl/intl.dart';

String now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  // static int msgid = 1;
  String messageText;
  final messageController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // getId();
  }

  // void getId() async {
  //   final firstId = await _firestore.collection("messages").get();
  //   for(var msgId in firstId.docs){
  //       id = msgId.data()["id"];
  //       print(id);
  //   }
  // }

  void getCurrentUser() async {
    try {
      // final user = await _auth.currentUser;
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;

        print(loggedInUser.email);
      }
    } catch (e) {
      print("Exception:$e");
      throw (e);
    }
  }

  // void getMessages() async {
  //  final messages = await _firestore.collection("messages").get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // messagesStream();
                // emailController.clear();
                passwordController.clear();
                Constants.prefs.setBool("loggedIn", false);
                _auth.signOut();

                Navigator.pushReplacementNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageController.clear();

                      // print("id: $msgid");
                      _firestore.collection("messages").add({
                        "text": messageText,
                        "sender": loggedInUser.email,
                      });
                      // msgid++;
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("messages").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print("No data in snapshot");
          }

          final messages = snapshot.data.docs.reversed;

          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.data()['text'];
            final messageSender = message.data()['sender'];

            final currentUser = loggedInUser.email;

            final messageBubble = MessageBubble(
              messageText: messageText,
              messageSender: messageSender,
              isMe: currentUser == messageSender,
            );

            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
                reverse: true,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: messageBubbles),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  final messageText;
  final messageSender;
  final bool isMe;

  MessageBubble({
    Key key,
    @required this.messageText,
    @required this.messageSender,
    this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            messageSender,
            style: TextStyle(color: Colors.black54),
          ),
          Material(
              elevation: 4.0,
              borderRadius: BorderRadius.only(
                topLeft: isMe ? Radius.circular(24) : Radius.zero,
                topRight: isMe ? Radius.zero : Radius.circular(24),
                bottomRight: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  messageText,
                  style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 16),
                ),
              )),
        ],
      ),
    );
  }
}
