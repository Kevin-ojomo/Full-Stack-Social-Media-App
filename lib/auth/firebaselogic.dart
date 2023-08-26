import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/models/post.dart';
import 'package:whatsapp_clone/models/user.dart' as model;
import 'package:whatsapp_clone/models/video.dart';
import 'package:whatsapp_clone/screens/chatpage.dart';

import 'package:whatsapp_clone/storage/storagemethods.dart';
import 'package:video_compress/video_compress.dart';

class AuthMethods {
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _firebase.currentUser!;

    DocumentSnapshot documentSnapshot = await _firestore.collection("users").doc(currentUser.uid).get();
    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> signup({required String email, required String password, required String confirmpassword, required Uint8List file, required String bio, required String username}) async {
    String res = "This User has successfully signedUp";
    try {
      if (email.isNotEmpty || password.isNotEmpty || confirmpassword.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || file != null) {
        UserCredential cred = await _firebase.createUserWithEmailAndPassword(email: email, password: password);
        String profilePicture = await Storage().storeImage("profPic", file, false);
        model.User _user = model.User(email: email, password: password, confirmpassword: confirmpassword, username: username, profPic: profilePicture, bio: bio, followers: [], following: []);
        _firestore.collection("users").doc(cred.user!.uid).set(_user.toJson());
        res = 'success';
      } else {
        res = "please enter all fields";
      }
    } catch (e) {
      e.toString();
    }
    return res;
  }

  Future<String> signin({
    required String email,
    required String password,
  }) async {
    String res = "Login Complete";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _firebase.signInWithEmailAndPassword(email: email, password: password);
      }
    } on FirebaseException catch (e) {
      e.toString();
    }
    return res;
  }

  Future<String> post(String description, DateTime time, Uint8List file, String uid) async {
    String res = "An Error Occurred";
    try {
      if (description.isNotEmpty || file != null) {
        String photoUrl = await Storage().storeImage("posts", file, true);
        String postIds = Uuid().v1();
        Post _post = Post(description: description, photoUrl: photoUrl, time: DateTime.now(), postId: postIds, uid: uid, likes: []);

        _firestore.collection("posts").doc(postIds).set(_post.toJson());
      }
    } catch (e) {
      e.toString();
    }
    return res;
  }

  Future<String> likepost(String uid, String postId, List likes) async {
    String res = "An error occurred";
    try {
      if (likes.contains(uid)) {
        _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayRemove([
            uid
          ])
        });
      } else {
        _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayUnion([
            uid
          ])
        });
      }
    } catch (e) {
      e.toString();
    }
    return res;
  }

  Future<String> signOut() async {
    String result = "Error signing out";
    try {
      await _firebase.signOut();
    } catch (e) {
      e.toString();
    }
    return result;
  }

  Future<String> postComment(String postId, String uid, String text, DateTime time) async {
    String res = "An Error Occured";
    try {
      String commentId = Uuid().v1();
      await _firestore.collection("posts").doc(postId).collection("comments").doc(commentId).set({
        "postId": postId,
        "uid": uid,
        "text": text,
        'time': DateTime.now()
      });
    } catch (e) {
      e.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followid) async {
    try {
      DocumentSnapshot snap = await _firestore.collection("users").doc(uid).get();
      List following = (snap.data as dynamic)['following'];
      List followers = (snap.data as dynamic)['followers'];

      if (following.contains(followid)) {
        await _firestore.collection("users").doc(uid).update({
          'followers': FieldValue.arrayRemove([
            uid
          ])
        });
        await _firestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayRemove([
            followid
          ])
        });
      } else {
        await _firestore.collection("users").doc(uid).update({
          'followers': FieldValue.arrayUnion([
            uid
          ])
        });
        await _firestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayUnion([
            followid
          ])
        });
      }
    } catch (e) {
      e.toString();
    }
  }

  compressVideo(String videopath) async {
    final compressVideo = await VideoCompress.compressVideo(videopath, quality: VideoQuality.DefaultQuality);
    return compressVideo!.file;
  }

  getthumbnail(String videopath) async {
    final thumbnail = VideoCompress.getFileThumbnail(videopath);
    return thumbnail;
  }

  Future<String> uploadvideo(String description, DateTime time, String videopath) async {
    String res = "An Error Occured";
    try {
      if (description.isNotEmpty) {
        final uid = await _firebase.currentUser!.uid;
        DocumentSnapshot userDocs = await _firestore.collection("users").doc(uid).get();
        final allDocs = await _firestore.collection("videos").get();
        int len = allDocs.docs.length;

        final videoUrl = await Storage().storeVideo(videopath, "Video $len");
        final thumbnailUrl = await Storage().uploadthumbnail(videopath, "Video $len");

        Video video = Video(username: (userDocs.data()! as Map<String, dynamic>)['username'], uid: uid, id: "Video $len", likes: [], description: description, videoUrl: videoUrl, thumbnail: thumbnailUrl);
        _firestore.collection("videos").doc("Video $len").set(video.toJson());
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }


}
