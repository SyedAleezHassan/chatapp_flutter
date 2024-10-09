import 'package:flutter/material.dart';

class StoryViewPage extends StatelessWidget {
  final String imageUrl;

  StoryViewPage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pop(context);
    });

    return Scaffold(
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }
}
