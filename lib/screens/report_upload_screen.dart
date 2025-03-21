import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ReportUploadScreen extends StatefulWidget {
  @override
  _ReportUploadScreenState createState() => _ReportUploadScreenState();
}

class _ReportUploadScreenState extends State<ReportUploadScreen> {
  File? _selectedFile;
  bool _isUploading = false;
  String? _analysisResult;

  final Color primaryColor = Color(0xFF003743);
  final Color secondaryColor = Color(0xFF0592ca);
  final Color accentColor = Color(0xFF32cfaa);
  final Color backgroundColor = Color(0xFF11151f);

  // Function to pick file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  // Function to upload file to backend
  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(_selectedFile!.path),
      });

      Dio dio = Dio();
      Response response = await dio.post(
        "http://your-backend-url/analyze", // Change this to your actual backend URL
        data: formData,
      );

      setState(() {
        _analysisResult = response.data["summary"];
      });
    } catch (e) {
      setState(() {
        _analysisResult = "Error processing file!";
      });
    }

    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Upload & Analyze Report",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 4,
        shadowColor: Colors.black45,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTitle("📂 Select Report File"),
            SizedBox(height: 10),
            _fileSelectionBox(),
            SizedBox(height: 20),
            _buildButton("Choose File (CSV/PDF)", Icons.upload_file,
                secondaryColor, _pickFile),
            SizedBox(height: 20),
            _buildButton(
              "Analyze File",
              Icons.analytics,
              _selectedFile == null || _isUploading ? Colors.grey : accentColor,
              _selectedFile == null || _isUploading ? null : _uploadFile,
            ),
            SizedBox(height: 30),
            if (_analysisResult != null) _buildAnalysisResult(),
          ],
        ),
      ),
    );
  }

  // Bordered Section Title
  Widget _buildTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: accentColor, width: 2)),
      ),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.7,
            color: accentColor),
      ),
    );
  }

  // File Selection Display Box
  Widget _fileSelectionBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.2),
        border: Border.all(color: accentColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _selectedFile == null
          ? Text("No file selected", style: TextStyle(color: Colors.white70))
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.insert_drive_file, color: secondaryColor),
                SizedBox(width: 10),
                Expanded(
                    child: Text(
                  _selectedFile!.path.split('/').last,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                )),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.redAccent),
                  onPressed: () => setState(() => _selectedFile = null),
                ),
              ],
            ),
    );
  }

  // Styled Buttons
  Widget _buildButton(
      String title, IconData icon, Color color, VoidCallback? onTap) {
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
          padding: EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
        onPressed: onTap,
      ),
    );
  }

  // Analysis Result Display
  Widget _buildAnalysisResult() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: accentColor, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: primaryColor.withOpacity(0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "📊 Analysis Result:",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: accentColor),
          ),
          SizedBox(height: 8),
          Text(
            _analysisResult!,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
