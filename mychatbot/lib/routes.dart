import 'package:flutter/widgets.dart';
import 'package:mychatbot/routes/chat.dart';
import 'package:mychatbot/routes/signup.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  SignUp.routeName: (BuildContext context) => SignUp(),
  Chat.routeName: (BuildContext context) => Chat(),
};
