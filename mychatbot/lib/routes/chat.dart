import 'package:flutter/material.dart';
import 'package:mychatbot/routes/signup.dart';
import 'package:http/http.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:mychatbot/models/messageModel.dart';

import '../constants.dart';

class Chat extends StatefulWidget {
  static const String routeName = '/chat';
  @override
  ChatState createState() => new ChatState();
}

class ChatState extends State<Chat> {
  List<ChatMessage> messages = [];
  final TextEditingController controller = new TextEditingController();
  String result = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyChatbot"),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, SignUp.routeName);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    ListView.builder(
                      itemCount: messages.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 10, bottom: 10),
                          child: Align(
                              alignment: (messages[index].messageType == "user"
                                  ? Alignment.topLeft
                                  : Alignment.topRight),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color:
                                        (messages[index].messageType == "user"
                                            ? Colors.grey.shade200
                                            : Colors.blue[200]),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Text(messages[index].messageContent))),
                        );
                      },
                    ),
                  ],
                ),
                TextField(
                    decoration: InputDecoration(hintText: "Type in here"),
                    onSubmitted: (String str) async {
                      setState(() {
                        messages.add(ChatMessage(
                            messageContent: str, messageType: 'user'));
                      });
                      var uri = Uri.http('$serverip:$serverport', '$str');
                      Response r = await get(uri);
                      if (r.body.startsWith("specialcharOPEN")) {
                        MapsLauncher.launchQuery(r.body
                            .replaceFirst(RegExp(r'specialcharOPEN '), ''));
                      }
                      setState(() {
                        // List<ChatMessage> botmessages = [];
                        List botmessagestrings = r.body
                            .replaceFirst(RegExp(r'specialcharOPEN'), '')
                            .split('\n');
                        // print(r.body.split(RegExp("\\n")));
                        print(r.body.split("\n")[0]);
                        for (var messagestring in botmessagestrings) {
                          ChatMessage message = ChatMessage(
                              messageContent: messagestring,
                              messageType: 'bot');
                          // botmessages.add(message);
                          messages.add(message);
                        }
                        // messages.addAll(botmessages);
                      });
                      controller.text = "";
                    },
                    controller: controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
