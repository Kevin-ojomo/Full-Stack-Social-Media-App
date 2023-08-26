import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/auth/auth.dart';
import 'package:whatsapp_clone/auth/firebaselogic.dart';
import 'package:whatsapp_clone/widgets/buttons.dart';
import 'package:whatsapp_clone/widgets/textfield.dart';

import '../utils/imagepicker.dart';

class RegisterPage extends StatefulWidget {
  final Function()? OnTap;
  const RegisterPage({Key? key, this.OnTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _biocontroller = TextEditingController();


  late Uint8List _file;
  void Signup() async {
    showCupertinoDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    if (_passwordController.text == _confirmpasswordController.text) {
      String res = await AuthMethods().signup(username: _usernamecontroller.text, bio: _biocontroller.text, email: _emailController.text, password: _passwordController.text, confirmpassword: _confirmpasswordController.text, file: _file);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords dont match")));
    }
  }

  addimage() async {
    Uint8List file = await PickImage().pickedImage(ImageSource.gallery);
    setState(() {
      _file = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(children: [
            Center(
                child: CircleAvatar(
              backgroundImage: MemoryImage(_file),
            )),
            Positioned(
                child: IconButton(
              onPressed: () => addimage(),
              icon: Icon(Icons.add),
            )),
            Text("Register to become a Member"),
            SizedBox(
              height: 20,
            ),
            MyTextField(obscuretext: false, controls: _usernamecontroller, maxLines: 1, Hinttext: "Username"),
            SizedBox(
              height: 20,
            ),
            MyTextField(obscuretext: false, controls: _biocontroller, maxLines: 1, Hinttext: "Tell us something about you"),
            SizedBox(
              height: 20,
            ),
            MyTextField(obscuretext: false, controls: _emailController, maxLines: 1, Hinttext: "Email"),
            SizedBox(
              height: 20,
            ),
            MyTextField(obscuretext: false, controls: _passwordController, maxLines: 1, Hinttext: "Password"),
            SizedBox(
              height: 20,
            ),
            MyTextField(obscuretext: false, controls: _confirmpasswordController, maxLines: 1, Hinttext: "Confirm Password"),
            SizedBox(
              height: 20,
            ),
            MyButton(
              text: "Register",
              onpressed: Signup,
            ),
            Row(
              children: [
                Text("Already have an account, "),
                GestureDetector(
                  child: Text(" SignIn"),
                  onTap: widget.OnTap,
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
