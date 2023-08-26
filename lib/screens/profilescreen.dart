import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/auth/auth.dart';
import 'package:whatsapp_clone/auth/loginorRegister.dart';
import 'package:whatsapp_clone/provider/userprovider.dart';
import 'package:whatsapp_clone/screens/chatpage.dart';
import 'package:whatsapp_clone/widgets/buttons.dart';
import 'package:whatsapp_clone/widgets/followbutton.dart';
import 'package:whatsapp_clone/models/user.dart' as model;

import '../auth/firebaselogic.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  final usercollection = FirebaseFirestore.instance.collection("users");
  final currentuser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> updatevalues(String field) async {
    String newvalue = "";
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: TextField(
          maxLines: 1,
          onChanged: (value) {
            newvalue = value;
          },
        ),
        actions: [
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(newvalue);
                  },
                  child: Text("Save")),
              ElevatedButton(onPressed: () {}, child: Text("cancel"))
            ],
          )
        ],
      ),
    );
    if (newvalue.trim().length > 0) {
      await usercollection.doc(currentuser?.uid).update({
        field: newvalue
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text(
                userData['username'],
              ),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(""),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, "posts"),
                                    buildStatColumn(followers, "followers"),
                                    buildStatColumn(following, "following"),
                                    FirebaseAuth.instance.currentUser!.uid == widget.uid
                                        ? MyButton(text: "Sign Out")
                                        : MyButton(
                                            text: "Message",
                                            onpressed: () => ChatPage(
                                              receiverUserUsername: user.username,
                                              receiversUserId: FirebaseAuth.instance.currentUser!.uid,
                                            ),
                                          )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid == widget.uid
                                        ? FollowButton(
                                            text: 'Sign Out',
                                            backgroundColor: Colors.black,
                                            textColor: Colors.black12,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              await AuthMethods().signOut();
                                              Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) => const LoginorRegister(),
                                                ),
                                              );
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  await AuthMethods().followUser(
                                                    FirebaseAuth.instance.currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: 'Follow',
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                borderColor: Colors.blue,
                                                function: () async {
                                                  await AuthMethods().followUser(
                                                    FirebaseAuth.instance.currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              userData['username'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(onPressed: () => updatevalues('username'), icon: Icon(Icons.settings))
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

                        return Container(
                          child: Image(
                            image: NetworkImage(snap['photourl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
