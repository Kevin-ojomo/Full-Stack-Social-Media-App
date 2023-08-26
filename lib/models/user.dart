import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String username;
  final String bio;
  final String email;
  final String password;
  final String confirmpassword;
  final String profPic;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.password,
    required this.confirmpassword,
    required this.username,
    required this.bio,
    required this.profPic,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        username: "username",
        bio: "bio",
        email: 'email',
        password: 'password',
        confirmpassword: 'confirmpassword',
        profPic: "profPic",
        "followers": followers,
        "following": following,
      };

  static fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return User(email: snap['email'], password: snap['password'], confirmpassword: snap["confirmpassword"], bio: snap['bio'], username: snap['username'], profPic: snap["profPic"], followers: snap['followers'], following: snap['following']);
  }
}
