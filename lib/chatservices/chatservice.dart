import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/models/message.dart';

class ChatServices extends ChangeNotifier {
  //get instance of firebase
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //SEND MESSAGE
  Future<void> sendMessage(String receiverId, String message) async {
    //get current user info
    final String currentUserId = await _firebase.currentUser!.uid;
    final String currentUserEmail = await _firebase.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newNessage = Message(senderId: currentUserId, senderEmail: currentUserEmail, receiverId: receiverId, message: message, timestamp: timestamp);

    //construct chat room id from current user id and  receiver id { SORTED TO ENSURE UNIQUENESS}
    List<String> ids = [
      currentUserId,
      receiverId
    ];
    ids.sort(); //sort the ids (this ensured the chat room id is always the same for any pair )
    String chatRoomId = ids.join("_"); // combine the ids into a single string to use as a chatroom

    //add new message to database
    await _firestore.collection("chat_room").doc(chatRoomId).collection("messages").add(newNessage.toMap());

    //Get Messages
 
  }
     Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //construct chat room id from user ids (sorted to ensure it matches the id used when sending the messages)
    List<String> ids = [
      userId,
      otherUserId
    ];

    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore.collection("chat_rooms").doc(chatRoomId).collection("messages").orderBy("timestamp", descending: false).snapshots();
  }
}
