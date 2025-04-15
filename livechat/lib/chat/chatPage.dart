import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livechat/auth/form.dart';
import 'package:livechat/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;

  const ChatPage({
    super.key, 
    required this.receiverUserEmail, 
    required this.receiverUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async{
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserId, _messageController.text);

      //clear after sending
      _messageController.clear();
    }
  }
@override
Widget build(BuildContext context) {
  try {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail)),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  } catch (e) {
    return Center(child: Text("Error in build: $e"));
  }
}


  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessage(
        widget.receiverUserId, 
        _firebaseAuth.currentUser!.uid), 

      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting){
          return const Text("loading...");
        }
        return ListView(
          children: snapshot.data!.docs.
          map((document) => _buildMessageItem(document)).toList(),
        );
      }
    
    
    );
  }
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
      ?Alignment.centerRight
      :Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child:Column(
        children: [
          Text(data['senderEmail']),
          Text(data['message'])
        ],
      )
    );
  }

  Widget _buildMessageInput(){
    return Row(
      children: [
        Expanded(
          child: FormContainer(
            controller: _messageController,
            hintText: "Enter message",
          ),
        ),
        IconButton(
          onPressed: sendMessage, 
          icon: const Icon(Icons.arrow_upward,
          size: 40,
          ),
        )
      ],
    );
  }
 
}