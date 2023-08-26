import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  final String description;
  final String photoUrl;
  final DateTime time;
  final String postId;
  final String uid;
  final List likes;

  const Post({required this.description, required this.photoUrl, required this.time, required this.postId, required this.uid, required this.likes});

  Map<String, dynamic> toJson() => {
        " description": description,
        "photoUrl": photoUrl,
        "time": time,
        "postId": postId,
        "uid": uid,
        "likes": likes

      };

  static fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Post(description: snap['description'], photoUrl: snap['photoUrl'], time: snap['time'], postId: snap['postId'], uid: snap["uid"], likes: snap['likes']);
  }
}
