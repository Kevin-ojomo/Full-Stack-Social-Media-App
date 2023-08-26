import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/auth/auth.dart';
import 'package:whatsapp_clone/auth/firebaselogic.dart';
import 'package:whatsapp_clone/utils/imagepicker.dart';
import 'package:whatsapp_clone/widgets/buttons.dart';
import 'package:whatsapp_clone/widgets/textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({Key? key, this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late Uint8List _file;

  void signip() async {
    showDialog(
        context: context,
        builder: ((context) => Center(
              child: CircularProgressIndicator(),
            )));
    String res = await AuthMethods().signin(email: _controller.text, password: _passwordController.text);

    if (res == "success") {
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Auth()));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Icon(Icons.person),
        SizedBox(
          height: 50,
        ),
        Text("Welcome back ypu've been missed"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: MyTextField(
            obscuretext: false,
            controls: _controller,
            maxLines: 1,
            Hinttext: "Email",
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: MyTextField(
            obscuretext: false,
            controls: _passwordController,
            maxLines: 1,
            Hinttext: "Password",
          ),
        ),
        SizedBox(
          height: 20,
        ),
        MyButton(
          text: "Login",
          onpressed: signip,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text("Not a member yet,"),
            GestureDetector(
              onTap: widget.onTap,
              child: Text(
                "Register Now",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        )
      ],
    )));
  }
}
