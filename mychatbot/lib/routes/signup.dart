import 'package:flutter/material.dart';
import 'package:mychatbot/routes/chat.dart';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';

class SignUp extends StatelessWidget {
  static const String routeName = '/signup';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup Form'),
      ),
      body: MyForm(),
    );
  }
}

class MyFormField extends StatelessWidget {
  MyFormField(this.controller, this.hintText);

  final controller, hintText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(border: InputBorder.none, hintText: hintText),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _nameFieldController = TextEditingController();
  final _workFieldController = TextEditingController();
  final _hobbiesFieldController = TextEditingController();
  final _fatherFieldController = TextEditingController();
  final _motherFieldController = TextEditingController();
  final _addressFieldController = TextEditingController();
  final _fathercontactsFieldController = TextEditingController();
  final _mothercontactsFieldController = TextEditingController();
  final _doctorcontactsFieldController = TextEditingController();
  final _bloodgroupFieldController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            MyFormField(_nameFieldController, 'Name'),
            MyFormField(_workFieldController, 'work'),
            MyFormField(_hobbiesFieldController, 'hobbies'),
            MyFormField(_fatherFieldController, 'Father name'),
            MyFormField(_motherFieldController, 'Mother name'),
            MyFormField(_addressFieldController, 'address'),
            MyFormField(_fathercontactsFieldController, 'father\'s mobile'),
            MyFormField(_mothercontactsFieldController, 'mother\'s mobile'),
            MyFormField(_doctorcontactsFieldController, 'doctor\'s mobile'),
            MyFormField(_bloodgroupFieldController, 'Blood Group'),
            MaterialButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  var uri = Uri.http('$serverip:$serverport', '/signup');
                  Map<String, String> data = {
                    'name': _nameFieldController.text,
                    'work': _workFieldController.text,
                    'hobbies': _hobbiesFieldController.text,
                    'father': _fatherFieldController.text,
                    'mother': _motherFieldController.text,
                    'address': _addressFieldController.text,
                    'fathermobile': _fathercontactsFieldController.text,
                    'mothermobile': _mothercontactsFieldController.text,
                    'doctormobile': _doctorcontactsFieldController.text,
                    'bloodgroup': _bloodgroupFieldController.text,
                  };
                  Response r = await post(uri, body: data);
                  if (r.statusCode == 200) {
                    Navigator.pushReplacementNamed(context, Chat.routeName);
                  } else {
                    Fluttertoast.showToast(
                      msg: "Error: Server returned ${r.statusCode} status code",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                }
              },
              child: Text('submit'),
            ),
          ],
        ),
      ),
    );
  }
}
