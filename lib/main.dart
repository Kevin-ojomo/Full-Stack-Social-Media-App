import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/auth/auth.dart';
import 'package:whatsapp_clone/auth/loginorRegister.dart';
import 'package:whatsapp_clone/provider/userprovider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCZ-xrXqD5D19Snauto-Fx_nLD7PLrBXGM",
          appId: "1:585119731880:web:eca6e4b3c42a755cee329d",
          messagingSenderId: "585119731880",
          projectId: "instagram-clone-4cea4",
          storageBucket: 'instagram-clone-4cea4.appspot.com'
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


     return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),)
      ],
       child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram Clone',
          darkTheme: ThemeData.dark(),
         theme: ThemeData.light(),
          
          themeMode: ThemeMode.system,
          
          
         home:Auth()
         
     
     
     
     
          ),
     );
      // );


  }
}
