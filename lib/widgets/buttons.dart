import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyButton extends StatelessWidget {
  final Function()? onpressed;
  final String text;
  const MyButton({Key? key, this.onpressed, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onpressed,
    
     child: Text(text)
    
    );
  }
}
