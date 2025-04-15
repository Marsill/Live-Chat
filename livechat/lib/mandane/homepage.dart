import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livechat/auth/firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:livechat/chat/chatPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;


  //sign out
  void signOut() {
    final authService = Provider.of<FirebaseAuthService>(context, listen: false);

    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          //sign out button
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
        ],
      ),

      body: _buildUserList(),
      
    );
  }

  // lst without the logged in user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Log the error to see what went wrong
          print("Error fetching users: ${snapshot.error}");
          return const Text('Error loading users');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        // Ensure data is available
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Text('No users available');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  //build individual list
Widget _buildUserListItem(DocumentSnapshot document) {
  Map<String, dynamic> data = document.data() as Map<String, dynamic>;

  String email = data['email'] ?? 'No Email';  // Safely access the email

  if (_auth.currentUser!.email != email) {
    return ListTile(
      title: Text(email),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverUserEmail: email,
              receiverUserId: data['uid'],
            ),
          ),
        );
      },
    );
  }

  return const SizedBox.shrink();
}

}