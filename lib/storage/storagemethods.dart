import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/auth/firebaselogic.dart';

class Storage {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> storeImage(String childname, Uint8List file, bool isPost) async {
    Reference ref = _firebaseStorage.ref().child(childname).child(_auth.currentUser!.uid);
    if (isPost) {
      String id = Uuid().v1();
      ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    var getdownloadUrl = snapshot.ref.getDownloadURL();
    return getdownloadUrl;
  }

  Future<String> storeVideo(String videopath, String id) async {
    Reference ref = await _firebaseStorage.ref(videopath).child(id);
    UploadTask uploadTask = ref.putFile(AuthMethods().compressVideo(videopath));
    TaskSnapshot snapshot = await uploadTask;
    var downloadUrl = snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadthumbnail(String videopath, String id) async {
    Reference ref = await _firebaseStorage.ref(videopath).child("thumbnails").child(id);
    UploadTask uploadTask = ref.putFile(AuthMethods().getthumbnail(videopath));
    TaskSnapshot snapshot = await uploadTask;
    var getdownloadUrl = snapshot.ref.getDownloadURL();
    return getdownloadUrl;
  }
}
