

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/chatservices/chatservice.dart';
import 'package:whatsapp_clone/widgets/chatbubble.dart';
import 'package:whatsapp_clone/widgets/textfield.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserUsername;
  final String receiversUserId;
  const ChatPage({super.key, required this.receiverUserUsername, required this.receiversUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(widget.receiversUserId, _messageController.text);
      //clear controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserUsername),
      ),
      body: Column(
        children: [
          //messages
          Expanded(child: _buildMessageList()),
          _buildMessageInput()
        ],
        //UserInput
      ),
    );
  }

  //Build Message List
  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
        stream: _chatServices.getMessages(widget.receiversUserId, _firebase.currentUser!.uid),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("Error Message"),
                      content: Text("An Error Occurred"),
                    ));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

           return ListView(children: snapshot.data!.docs.map<Widget>((document) => _buildMessageItem(document)).toList());
        }));
  }

  //Build Message Item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //Align the messages to the right if the sender is the current user, otherwise left
    var alignment = (data['senderId'] == _firebase.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
          crossAxisAlignment: (data['senderId'] == _firebase.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(data['username']),
          ChatBubble(message: data['message']),
        ],
      ),
    );
  }

  //Build Message Input
  Widget _buildMessageInput() {
    return Row(
      children: [
        //textfield
        Expanded(child: MyTextField(obscuretext: false, controls: _messageController, maxLines: 10, Hinttext: "Message")),
        SizedBox(
          width: 10,
        ),
        IconButton(onPressed: sendMessage, icon: Icon(Icons.send))
      ],
    );
  }
}
