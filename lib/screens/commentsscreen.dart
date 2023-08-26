import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/auth/firebaselogic.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/provider/userprovider.dart';
import 'package:whatsapp_clone/widgets/commentcard.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  final snap;
  const CommentsScreen({Key? key, required this.postId, required this.snap}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController = TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await AuthMethods().postComment(widget.postId, uid, commentEditingController.text, DateTime.now());

      if (res != 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.toString())));
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    // final User user = Provider.of<UserProvider>(context).getUser;
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.snap['photoUrl']),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as' + widget.snap['username'],
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                  widget.snap['uid'],
                  user.username,
                  widget.snap['photoUrl'],
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
