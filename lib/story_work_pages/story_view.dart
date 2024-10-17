// import 'package:flutter/material.dart';

// class StoryViewPage extends StatelessWidget {
//   final String imageUrl;

//   StoryViewPage({required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(Duration(seconds: 5), () {
//       Navigator.pop(context);
//     });

//     return Scaffold(
//       body: Center(
//         child: Image.network(
//           imageUrl,
//           fit: BoxFit.cover,
//           height: double.infinity,
//           width: double.infinity,
//         ),
//       ),
//     );
//   }
// }

//chat wala design
import 'package:flutter/material.dart';

class StoryViewPage extends StatelessWidget {
  final String imageUrl;

  StoryViewPage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Delay to close the story after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Display the story image
          Center(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          // Progress bar at the top to indicate the time
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: LinearProgressIndicator(
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              value: 1.0, // Full width since the duration matches the delay
              minHeight: 4,
            ),
          ),
          // Optional back button (like WhatsApp) to exit the story
          Positioned(
            top: 40,
            left: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
