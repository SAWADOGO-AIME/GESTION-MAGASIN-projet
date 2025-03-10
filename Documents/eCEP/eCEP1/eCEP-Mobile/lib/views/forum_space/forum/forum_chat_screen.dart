import 'package:ecep/constants/colors.dart';
import 'package:ecep/views/forum_space/message_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ecep/models/forum.dart';
import 'package:ecep/services/api_forum.dart';

class ChatScreen extends StatefulWidget {
  final Room room;
  const ChatScreen({super.key, required this.room});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _controller = TextEditingController();
  late Future<List<Message>> _messagesFuture;

  @override
  void initState() {
    super.initState();
    _messagesFuture = _api.getMessages(widget.room.id!);
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    try {
      await _api.sendMessage(widget.room.id!, _controller.text);
      _controller.clear();

      setState(() {
        _messagesFuture = _api.getMessages(widget.room.id!);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur d\'envoi: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Message>>(
              future: _messagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucun message'));
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    return MessageBubble(
                      message: message,
                      isUser: message.isFromCurrentUser,
                      time: '', // Ce paramètre est désormais inutile car nous utilisons message.getFormattedTime()
                    );
                  },
                );
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, -2),
            )
          ]
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Écrire un message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.accent),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Future<List<Message>>>('_messagesFuture', _messagesFuture));
  }
}