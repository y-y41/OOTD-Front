import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServerTestScreen extends StatelessWidget {
  const ServerTestScreen({Key? key}) : super(key: key);

  Future<void> testConnection(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('https://ootd-app-829475977871.asia-northeast3.run.app'),
      );

      if (response.statusCode == 200) {
        print('Connection successful! Response: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection successful!')),
        );
      } else {
        print('Failed to connect. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to connect: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error connecting to server: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Connection Test'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => testConnection(context),
          child: const Text('Test Server Connection'),
        ),
      ),
    );
  }
}
