import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp_clone/screens/searchscreen.dart';
import 'package:whatsapp_clone/widgets/postcards.dart';
import 'package:whatsapp_clone/widgets/videocard.dart';

class FeedScreen extends StatefulWidget {
  final snap;

  const FeedScreen({Key? key, this.snap}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final currentuser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    bool newValue = false;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: UserAccountsDrawerHeader(
        currentAccountPicture: widget.snap['profPic'],
        accountName: Text('${currentuser!.email}'),
        accountEmail: Text('${widget.snap['email']}'),
        otherAccountsPictures: [
          Column(
            children: [
              Switch(
                  value: newValue,
                  onChanged: ((bool value) {
                    newValue = value;
                    ThemeData.dark();
                  })),
              GestureDetector(
                onTap: (() => Navigator.of(context).push(MaterialPageRoute(builder: (context) => searchScreen()))),
                child: ListTile(
                  leading: Icon(Icons.search),
                  title: Text("Search"),
                ),
              )
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: Colors.black12,
          height: 32,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.messenger_outline,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Column(
              children: [
                Container(
                  child: PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                ),
                Container(child: VideoCard(snap: snapshot.data!.docs[index])),
              ],
            ),
          );
        },
      ),
    );
  }
}
