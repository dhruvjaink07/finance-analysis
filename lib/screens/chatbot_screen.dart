import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:techblitz/screens/chat_service.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _textController = TextEditingController();
  File? _uploadedFile;
  String? _fileName;

  final Color primaryColor = Color(0xFF003743);
  final Color secondaryColor = Color(0xFF0592ca);
  final Color accentColor = Color(0xFF32cfaa);
  final Color backgroundColor = Color(0xFF11151f);
  final ChatbotService _chatbotService = ChatbotService();
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
    }
  }

  // Function to send message (text + file if selected)
  void _sendMessage() async {
    String text = _textController.text.trim();

    if (text.isEmpty && _uploadedFile == null) return;

    String messageContent = "";

    if (_uploadedFile != null) {
      messageContent += "📄 File: $_fileName";
    }

    if (text.isNotEmpty) {
      messageContent += messageContent.isEmpty ? text : "\n💬 $text";
    }

    // Add the user's message to the chat
    _addMessage(messageContent, isUser: true);

    setState(() {
      _textController.clear();
      _uploadedFile = null;
      _fileName = null;
    });

    // Call the ChatbotService to get the AI response
    String? aiResponse = await _chatbotService.getChatResponse(text);

    // Add the AI's response to the chat
    if (aiResponse != null) {
      // Format the response for better readability
      String formattedResponse = _formatResponse(aiResponse);
      _addMessage("🤖 $formattedResponse", isUser: false);
    } else {
      _addMessage("🤖 Sorry, I couldn't process your request.", isUser: false);
    }
  }

  // Function to add message to chat
  void _addMessage(String message, {required bool isUser}) {
    setState(() {
      _messages.insert(0, {"text": message, "isUser": isUser});
    });
  }

  String _formatResponse(String response) {
    // Split the response into sections based on newlines for better readability
    List<String> sections = response.split("\\n\\n");
    return sections.join("\n\n"); // Add spacing between sections
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Finance AI Chatbot",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 4,
      ),
      body: Column(
        children: [
          _buildTitle("💬 Chat with AI"),
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildChatBubble(message["text"], message["isUser"]);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  // Section Title with Border
  Widget _buildTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: accentColor, width: 2)),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: accentColor),
      ),
    );
  }

  // Custom Chat Bubble UI
  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isUser ? secondaryColor : Colors.grey[800],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: isUser ? Radius.circular(10) : Radius.zero,
            bottomRight: isUser ? Radius.zero : Radius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // Input field with send & attach buttons
  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: accentColor),
            onPressed: _pickFile,
          ),
          if (_uploadedFile != null)
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file, color: accentColor),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _fileName!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.redAccent),
                    onPressed: () => setState(() => _uploadedFile = null),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: TextField(
                controller: _textController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Type your message...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
              ),
            ),
          IconButton(
            icon: Icon(Icons.send, color: accentColor),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
