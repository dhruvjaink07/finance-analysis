import 'package:flutter/material.dart';
import 'report_upload_screen.dart';
import 'chatbot_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Finance Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("📊 Revenue Growth"),
            _buildPlaceholder("Line Chart Placeholder"),
            SizedBox(height: 20),
            _buildSectionTitle("💰 Cash Flow"),
            _buildPlaceholder("Bar Chart Placeholder"),
            SizedBox(height: 30),
            _buildNavigationButtons(context),
          ],
        ),
      ),
    );
  }

  // Styled Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.5),
    );
  }

  // Placeholder for Charts (Replace with fl_chart later)
  Widget _buildPlaceholder(String text) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child:
            Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ),
    );
  }

  // Navigation Buttons
  Widget _buildNavigationButtons(BuildContext context) {
    return Column(
      children: [
        _buildButton(
          context,
          title: "Upload & Analyze Report",
          icon: Icons.upload_file,
          color: Colors.blueAccent,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReportUploadScreen()));
          },
        ),
        SizedBox(height: 12),
        _buildButton(
          context,
          title: "Go to AI Chatbot",
          icon: Icons.chat_bubble_outline,
          color: Colors.green,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatbotScreen()));
          },
        ),
      ],
    );
  }

  // Custom Button Widget
  Widget _buildButton(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(title, style: TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
      ),
    );
  }
}
