import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:
      Column(
        children: [
          CustomScrollView(
            slivers: [
               SliverAppBar(
                pinned: false,
                snap: true,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset("name"),
                ),
                
              ), ],
              
     ),
     Center(child: Text(""),)
        ],
      ),
    );
  }
}
