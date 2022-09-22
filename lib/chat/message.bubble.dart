// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.messages, this.isMe,
      {required this.userName, required this.userImage, this.key})
      : super(key: key);
  final String messages;
  final bool isMe;
  final String userName;
  final String userImage;
  final Key? key;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isMe ? Colors.grey : Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: !isMe
                          ? const Radius.circular(0)
                          : const Radius.circular(12),
                      bottomRight: isMe
                          ? const Radius.circular(0)
                          : const Radius.circular(12)),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                width: 170,
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                          color: isMe ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      messages,
                      style: TextStyle(
                          color: isMe
                              ? Colors.black
                              : Theme.of(context)
                                  .accentTextTheme
                                  .headline1!
                                  .color,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: -10.0,
          right: isMe ? 155.0 : null,
          left: isMe ? null : 155.0,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).backgroundColor,
            radius: 20,
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
    );
  }
}
