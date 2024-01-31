import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreenInd extends StatefulWidget {
  const ChatScreenInd({super.key, required this.chat, required this.friend});

  final Chat chat;
  final ChatUser friend;

  @override
  State<ChatScreenInd> createState() {
    return _ChatScreenIndState();
  }
}

class _ChatScreenIndState extends State<ChatScreenInd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.friend.imageUrl),
            ),
            SizedBox(width: 10),
            Text(widget.friend.name),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Column(
        children: [Expanded(child: ChatMessages(widget.chat))],
      ),
      bottomSheet: NewMessage(
        chat: widget.chat,
      ),
    );
  }
}
