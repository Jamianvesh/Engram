import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupport {
  static Future<void> show(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@engramapp.com',
      queryParameters: {
        'subject': 'App Support Request',
        'body': 'Hello, I need help with...',
      },
    );

    try {
      if (!await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open email app")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not open email app")));
    }
  }
}
