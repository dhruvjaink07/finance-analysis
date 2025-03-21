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
      appBar: AppBar(title: Text("Upload & Analyze Report")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_selectedFile != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.insert_drive_file, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(_selectedFile!.path.split('/').last,
                          overflow: TextOverflow.ellipsis)),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () => setState(() => _selectedFile = null),
                  ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.upload_file),
              label: Text("Choose File (CSV/PDF)"),
              onPressed: _pickFile,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _selectedFile == null || _isUploading ? null : _uploadFile,
              child: _isUploading
                  ? CircularProgressIndicator()
                  : Text("Analyze File"),
            ),
            SizedBox(height: 30),
            if (_analysisResult != null)
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "📊 Analysis Result:\n$_analysisResult",
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
