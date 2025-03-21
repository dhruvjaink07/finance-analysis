import 'dart:math';
import 'package:dio/dio.dart';

class ChatbotService {
  final Dio _dio = Dio();
  final Random _random = Random();

  Future<String?> getChatResponse(String prompt) async {
    // Original code for real backend connection (commented out for now)
    /*
    try {
      final response = await _dio.post(
        "http://127.0.0.1:5000/Rmodel",
        data: {"prompt": prompt},
      );
      return response.data['message'];
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        print("Connection error: Unable to reach the server.");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        print("Timeout error: Server took too long to respond.");
      } else {
        print("Error getting chat response: $e");
      }
      return null;
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
    */

    // Dummy response for testing
    try {
      // Simulate a delay to mimic a real network request
      await Future.delayed(Duration(seconds: 1));

      // Generate random numbers for the response
      double revenueGrowth = double.parse((_random.nextDouble() * 10)
          .toStringAsFixed(1)); // Random between 0-10%
      double cashFlowProjections = double.parse((_random.nextDouble() * 10)
          .toStringAsFixed(1)); // Random between 0-10%
      double profitMargins = double.parse((_random.nextDouble() * 20)
          .toStringAsFixed(1)); // Random between 0-20%

      // Return a dummy response with random numbers
      return "Response for \"$prompt\".\n\n"
          "Here is some additional information:\n"
          "- Revenue Growth: $revenueGrowth%\n"
          "- Cash Flow Projections: $cashFlowProjections%\n"
          "- Profit Margins: Stable at $profitMargins%";
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }
}
