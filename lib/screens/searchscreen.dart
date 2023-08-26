import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/screens/profilescreen.dart';
import 'package:whatsapp_clone/widgets/textfield.dart';

class searchScreen extends StatefulWidget {
  const searchScreen({Key? key}) : super(key: key);

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isShowusers = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Form(
              child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(labelText: "Search for Users...."),
            onFieldSubmitted: (String value) {
              setState(() {
                _isShowusers = true;
              });
              print(value);
            },
          )),
        ),
        body: _isShowusers
            ? FutureBuilder(
                future: FirebaseFirestore.instance.collection("users").where("username", isGreaterThanOrEqualTo: _searchController.text).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return ListView.builder(itemBuilder: (context, index) {
                        return InkWell(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage((snapshot.data as dynamic).docs[index]['profPic']),
                              ),
                              title: Text((snapshot.data as dynamic).docs[index]['username']),
                            ),
                            onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: ((context) => ProfileScreen(uid: (snapshot.data as dynamic).docs[index]['uid']))),
                                ));
                      });
                    }
                  }
                  if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return CircularProgressIndicator();
                })
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection("posts").where("photoUrl").get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return CircularProgressIndicator();
                  }
                  return GridView.builder(
                    itemBuilder: ((context, index) {
                      return Image.network(
                        (snapshot.data as dynamic).docs[index]['photoUrl'],
                        fit: BoxFit.cover,
                      );
                    }),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (snapshot.data as dynamic).docs[Index].length),
                  );
                }));
  }
}
