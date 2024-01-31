import 'package:chat_app/models/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final firestore = FirebaseFirestore.instance;

class NewMessage extends StatefulWidget {
  const NewMessage({super.key, required this.chat});

  final Chat chat;

  @override
  State<NewMessage> createState() {
    return _NewMessagetate();
  }
}

class _NewMessagetate extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    print(widget.chat);
    final message = _messageController.text;

    if (message.trim().isEmpty) {
      return;
    }

    final myUser = FirebaseAuth.instance.currentUser!;
    final chat = widget.chat;

    firestore.collection('chats').doc(chat.chatId).collection('messages').add({
      'text': message,
      'userId': myUser.uid,
      'sentAt': Timestamp.now(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 15, top: 8, bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 17),
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              decoration: InputDecoration(
                  hintText: 'Send a message',
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 17,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withAlpha(220))),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              const CircleAvatar(
                radius: 26,
              ),
              IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send_rounded),
                color: Theme.of(context).colorScheme.primary,
              )
            ],
          )
        ],
      ),
    );
  }
}
