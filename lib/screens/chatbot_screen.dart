import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: 'user');
  final _bot = const types.User(id: 'bot');
  final _uuid = Uuid();
  File? _uploadedFile;
  String? _fileName;

  // Function to pick file (CSV/PDF)
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _uploadedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });

      // Add file upload message to chat
      final message = types.TextMessage(
        id: _uuid.v4(),
        author: _user,
        text: "📄 Uploaded file: $_fileName",
      );
      _addMessage(message);
    }
  }

  // Function to send message
  void _sendMessage(types.PartialText message) {
    final textMessage = types.TextMessage(
      id: _uuid.v4(),
      author: _user,
      text: message.text,
    );

    _addMessage(textMessage);
    _getBotResponse(message.text);
  }

  // Function to simulate bot response
  void _getBotResponse(String text) {
    Future.delayed(Duration(milliseconds: 800), () {
      final response = types.TextMessage(
        id: _uuid.v4(),
        author: _bot,
        text: "🤖 AI Analysis: Here's an insight for '$text'...",
      );
      _addMessage(response);
    });
  }

  // Function to add message to chat
  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Finance Assistant",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: const Icon(Icons.help_outline, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Chat(
              messages: _messages,
              user: _user,
              onSendPressed: _sendMessage,
              theme: DefaultChatTheme(
                primaryColor: Colors.green,
                secondaryColor: Colors.blue,
                backgroundColor: Colors.black,
                inputBackgroundColor: Colors.black,
                inputTextColor: Colors.white,
                inputBorderRadius: BorderRadius.circular(25),
                inputContainerDecoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 1),
                  borderRadius: BorderRadius.circular(25),
                ),
                inputTextStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          if (_uploadedFile != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _fileName!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => setState(() => _uploadedFile = null),
                  ),
                ],
              ),
            ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
