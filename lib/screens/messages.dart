import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/models/user.dart' as model;
import 'package:whatsapp_clone/provider/userprovider.dart';

import 'chatpage.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("${user.profPic}"),
        centerTitle: true,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.profPic),
              )
            ],
          )
        ],
      ),
      body: _buildUserList()
    );
  }


    Widget _buildUserList() {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").where("chat-rooms").snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                        title: Text("Network Error"),
                        content: Text(" Something Went Wrong"),
                      ));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              return ListView(children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList());
            }
          }));
    }
  

  
    Widget _buildUserListItem(DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      //display all users except the current user
      if (FirebaseAuth.instance.currentUser!.uid != data['uid']) {
        return ListTile(
          title: data['username'],
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(receiverUserUsername: data['username'], receiversUserId: data['uid'],)));
          },
        );
      } else {
        return Center(
          child: Text("No Data Found"),
        );
      }
    }
  
}
