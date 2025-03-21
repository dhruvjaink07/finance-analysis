import 'package:flutter/material.dart';
import 'report_upload_screen.dart';
import 'chatbot_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class HomeScreen extends StatelessWidget {
  final Color primaryColor = const Color(0xFF003743);
  final Color secondaryColor = const Color(0xFF0592ca);
  final Color accentColor = const Color(0xFF32cfaa);
  final Color backgroundColor = const Color(0xFF11151f);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Finance Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 4,
        shadowColor: Colors.black45,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionWithBorder("📊 Revenue Growth", _buildLineChart()),
            const SizedBox(height: 20),
            _buildSectionWithBorder("💰 Cash Flow", _buildBarChart()),
            const SizedBox(height: 30),
            _buildNavigationButtons(context),
          ],
        ),
      ),
    );
  }

  // Bordered Section with Enhanced Styling
  Widget _buildSectionWithBorder(String title, Widget chart) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: accentColor, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: primaryColor.withOpacity(0.2),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title),
          const SizedBox(height: 10),
          SizedBox(height: 150, child: chart),
        ],
      ),
    );
  }

  // Styled Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.7,
          color: accentColor),
    );
  }

  // Dummy Line Chart
  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              7,
              (index) => FlSpot(index.toDouble(), Random().nextDouble() * 10),
            ),
            isCurved: true,
            color: accentColor,
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  // Dummy Bar Chart
  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          7,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: Random().nextDouble() * 10,
                color: accentColor,
                width: 16,
              ),
            ],
          ),
        ),
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
          color: secondaryColor,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReportUploadScreen()));
          },
        ),
        const SizedBox(height: 12),
        _buildButton(
          context,
          title: "Go to AI Chatbot",
          icon: Icons.chat_bubble_outline,
          color: accentColor,
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
        icon: Icon(icon, size: 22, color: backgroundColor),
        label: Text(title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: backgroundColor)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
        onPressed: onTap,
      ),
    );
  }
}
