import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatTray extends StatelessWidget {
  ChatTray(this.chat, this.friend, {super.key});

  final Chat chat;
  final ChatUser friend;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatScreenInd(chat: chat, friend: friend)));
      },
      child: SizedBox(
        width: 400,
        child: Card(
          borderOnForeground: false,
          surfaceTintColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                if (friend.imageUrl != 'imageUrl')
                  CircleAvatar(
                    backgroundImage: NetworkImage(friend.imageUrl),
                  ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  friend.name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 23),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
