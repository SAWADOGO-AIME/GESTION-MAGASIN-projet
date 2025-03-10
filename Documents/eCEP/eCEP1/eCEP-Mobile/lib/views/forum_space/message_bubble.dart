import 'package:ecep/constants/colors.dart';
import 'package:ecep/models/forum.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isUser;
  final String time;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isUser,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isUser && message.userName != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 4),
                    child: Text(
                      message.userName!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.primary : Colors.grey[200],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12, right: 12),
                  child: Text(
                    message.getFormattedTime(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return message.userAvatar != null && message.userAvatar!.isNotEmpty
        ? CircleAvatar(
      radius: 16,
      backgroundImage: NetworkImage(message.userAvatar!),
    )
        : CircleAvatar(
      radius: 16,
      backgroundColor: isUser ? AppColors.accent : Colors.grey,
      child: Text(
        message.userName != null && message.userName!.isNotEmpty
            ? message.userName![0].toUpperCase()
            : '?',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}