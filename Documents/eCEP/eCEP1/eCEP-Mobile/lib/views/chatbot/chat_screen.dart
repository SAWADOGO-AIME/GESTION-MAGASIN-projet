import 'dart:convert';
import 'package:ecep/models/forum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eCEP Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFf8f9fa),
      ),
      home: ChatScreen(room: Room(name: 'Assistant')), // Ajoutez une Room par défaut
    );
  }
}
class ChatScreen extends StatefulWidget {
  final Room room; // Ajoutez cette ligne

  const ChatScreen({super.key, required this.room}); // Corrigez le constructeur

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add(Message(text: message, isUser: true, date: DateTime.now()));
      _isLoading = true;
    });

    _controller.clear();
    try {
      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Authorization':
          'Bearer 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',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'http://localhost:8000/',
          'X-Title': 'eCEP Assistant',
        },
        body: jsonEncode({
          "model": "deepseek/deepseek-r1:free",
          "messages": [{"role": "user", "content": message}]
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = json.decode(responseBody);
        final botResponse = responseData['choices'][0]['message']['content'] ?? 'Pas de réponse';

        setState(() {
          _messages.add(Message(
            text: botResponse,
            isUser: false,
            date: DateTime.now(),
          ));
        });
      } else {
        _showError('Erreur API: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Erreur de connexion: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eCEP Assistant'),
        backgroundColor: const Color(0xFF2A5C82),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0 && _isLoading) {
                  return const TypingIndicator();
                }
                final adjustedIndex = index - (_isLoading ? 1 : 0);
                final messageIndex = _messages.length - 1 - adjustedIndex;
                if (messageIndex < 0 || messageIndex >= _messages.length) {
                  return const SizedBox.shrink();
                }
                final message = _messages[messageIndex];
                return MessageBubble(
                  message: message.text,
                  isUser: message.isUser,
                  time: DateFormat('HH:mm').format(message.date),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Entrez votre message ici...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF2A5C82)),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;
  final DateTime date;

  Message({
    required this.text,
    required this.isUser,
    required this.date,
  });
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final String time;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showCopyMenu(context, message);
      },
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser ? const Color(0xFF2A5C82) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
              bottomRight: isUser ? Radius.zero : const Radius.circular(16),
            ),
            boxShadow: [
              if (!isUser)
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarkdownBody(
                data: message,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    color: isUser ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                  h3: TextStyle(
                    color: isUser ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  code: TextStyle(
                    backgroundColor: isUser ? Colors.black12 : Colors.grey[200],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: isUser ? Colors.white70 : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCopyMenu(BuildContext context, String text) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.content_copy,
                  color: Colors.blue,
                ),
                title: const Text('Copier le texte'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Texte copié !')),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            _buildDot(1),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300 + (index * 200)),
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: const Color(0xFF2A5C82),
          borderRadius: BorderRadius.circular(4),
        ),
        curve: Curves.easeInOut,
      ),
    );
  }
}