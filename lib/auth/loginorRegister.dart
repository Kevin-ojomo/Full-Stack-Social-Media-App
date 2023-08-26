import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:whatsapp_clone/screens/login.dart';
import 'package:whatsapp_clone/screens/register.dart';

class LoginorRegister extends StatefulWidget {
  const LoginorRegister({Key? key}) : super(key: key);

  @override
  State<LoginorRegister> createState() => _LoginorRegisterState();
}

class _LoginorRegisterState extends State<LoginorRegister> {
  late bool showLogin = true;

  void togglebutton() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginPage(
        onTap: togglebutton,
      );
    } else {
      return RegisterPage(
        OnTap: togglebutton,
      );
    }
  }
}
