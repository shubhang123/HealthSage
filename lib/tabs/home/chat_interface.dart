import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.TextMessage> _messages = [];
  final types.User _user =
      const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

  @override
  void initState() {
    super.initState();
    _messages = [
      types.TextMessage(
        author: const types.User(id: 'health-sage'),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text:
            'Hello I am Health Sage, your Virtual Assistant. Feel free to ask me any questions or share any concerns related to your health condition.\n\nAs your virtual assistant, I\'d like to suggest some frequently asked questions to get started:\n\n* How do I manage my type 2 diabetes?\n* How can I improve my blood pressure?\n* How can I alleviate my asthma symptoms?\n* How can I increase my exercise routine while staying active?\n* How can I improve my sleep quality?\n\nPlease let me know if there\'s anything on your mind, and I\'ll do my best to help!\n\n(Note: I remember that you have Type 2 diabetes, hypertension, and asthma. You\'re taking Metformin, Lisinopril, and using an Albuterol inhaler. You have allergies to penicillin, peanuts, and pollen. Your medical history includes an appendectomy and pneumonia. You\'ve received the COVID-19 and influenza vaccines.)',
      ),
    ];
  }

  void _addMessage(types.TextMessage message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          showUserAvatars: true,
          showUserNames: true,
          user: _user,
        ),
      );
}
