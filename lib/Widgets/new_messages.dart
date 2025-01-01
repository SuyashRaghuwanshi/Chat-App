import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});
  @override
  State<NewMessages> createState() {
    return NewMessagesState();
  }
}

class NewMessagesState extends State<NewMessages> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitText() async {
    final _enteredText = _messageController.text.trim();
    if (_enteredText.isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    try {
      final user = FirebaseAuth.instance.currentUser!;
      if (user == null) {
        throw Exception('Users not logged in');
      }
      //send request to firestore
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!userData.exists || userData.data() == null) {
        throw Exception('User data not found.');
      }

      final userDataMap = userData.data()!;
      if (!userDataMap.containsKey('username') ||
          !userDataMap.containsKey('image_url')) {
        throw Exception('User data is incomplete.');
      }
      await FirebaseFirestore.instance.collection('chat').add(
        {
          'text': _enteredText,
          'createdAt': Timestamp.now(),
          'userId': user.uid,
          'username': userData.data()!['username'],
          'userImage': userData.data()!['image_url'],
        },
      );
      _messageController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending message: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message..'),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _submitText,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
