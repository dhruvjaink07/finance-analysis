import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatbotScreen extends StatefulWidget {
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
  void _sendMessage(String text) {
    if (text.isEmpty) return;

    final message = types.TextMessage(
      id: _uuid.v4(),
      author: _user,
      text: text,
    );

    _addMessage(message);
    _getBotResponse(text);
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
      appBar: AppBar(title: Text("Finance AI Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: Chat(
              messages: _messages,
              onSendPressed: (partialText) => _sendMessage(partialText.text),
              user: _user,
            ),
          ),
          if (_uploadedFile != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text(_fileName!, overflow: TextOverflow.ellipsis)),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () => setState(() => _uploadedFile = null),
                  ),
                ],
              ),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  // Input field with send & attach buttons
  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.blue),
            onPressed: _pickFile,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Ask about revenue, risk, investment...",
                border: InputBorder.none,
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
