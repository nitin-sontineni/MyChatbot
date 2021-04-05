import 'package:flutter/material.dart';
import 'package:mychatbot/routes.dart';
import 'package:mychatbot/routes/chat.dart';
import 'package:mychatbot/routes/signup.dart';
import 'package:http/http.dart';
import 'constants.dart';

Future<bool> userexists() async {
  var uri = Uri.http('$serverip:$serverport', '/userexists');
  Response r = await get(uri);
  print('BOdy: ${r.body}');
  return r.body.isNotEmpty;
}

void main() async {
  final bool isLoggedIn = await userexists();
  final ChatBot chatbot = ChatBot(
    initialRoute: isLoggedIn ? Chat.routeName : SignUp.routeName,
  );
  runApp(chatbot);
}

class ChatBot extends StatefulWidget {
  ChatBot({this.initialRoute});
  final String initialRoute;
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  Future<String> isuser() async {
    var uri = Uri.http('$serverip:$serverport', '/isuser');
    Response r = await get(uri);
    print('BOdy: ${r.body}');
    return r.body;
  }

  @override
  Widget build(BuildContext context) {
    // isuser().then((value) {
    //   if (value.isNotEmpty) {
    //     initialRoute = Chat.routeName;
    //     // Navigator.pushReplacementNamed(context, Chat.routeName);
    //   }
    // });
    return MaterialApp(
      title: 'Chatbot',
      initialRoute: widget.initialRoute,
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
