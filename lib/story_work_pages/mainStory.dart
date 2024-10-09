// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:io';
// import 'package:intl/intl.dart';

// class StoryPage extends StatefulWidget {
//   @override
//   _StoryPageState createState() => _StoryPageState();
// }

// class _StoryPageState extends State<StoryPage> {
//   final _firestore = FirebaseFirestore.instance;
//   final _auth = FirebaseAuth.instance;
//   final _storage = FirebaseStorage.instance;
//   final ImagePicker _picker = ImagePicker();

//   // Future<void> _pickImage() async {
//   //   try {
//   //     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//   //     if (image != null) {
//   //       // Use the picked image here, for example, upload it to Firebase
//   //       print('Image selected: ${image.path}');
//   //     }
//   //   } catch (e) {
//   //     print('Error picking image: $e');
//   //   }
//   // }

//   // Upload a story to Firebase Storage and Firestore
//   Future<void> uploadStory() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       File imageFile = File(pickedFile.path);

//       try {
//         // Upload image to Firebase Storage
//         String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//         Reference storageRef = _storage.ref().child('stories/$fileName');
//         await storageRef.putFile(imageFile);
//         print('Image uploaded suxexfully');

//         // Get the image URL
//         String imageUrl = await storageRef.getDownloadURL();

//         // Save story metadata to Firestore
//         await _firestore.collection('stories').add({
//           'userId': _auth.currentUser!.uid,
//           'imageUrl': imageUrl,
//           'timestamp': FieldValue.serverTimestamp(),
//         });

//         print('Story uploaded successfully');
//       } catch (e) {
//         print('Error uploading story: $e');
//       }
//     }
//   }

//   // Get stories that are within the last 24 hours
//   Stream<QuerySnapshot> getRecentStories() {
//     DateTime now = DateTime.now();
//     DateTime last24Hours = now.subtract(Duration(hours: 24));

//     return _firestore
//         .collection('stories')
//         .where('timestamp', isGreaterThan: last24Hours)
//         .snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Stories'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: uploadStory,
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: getRecentStories(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           final stories = snapshot.data!.docs;
//           List<Widget> storyWidgets = [];

//           for (var story in stories) {
//             var storyData = story.data() as Map<String, dynamic>;
//             var imageUrl = storyData['imageUrl'];
//             var timestamp = (storyData['timestamp'] as Timestamp).toDate();
//             var formattedTime = DateFormat('hh:mm a').format(timestamp);

//             storyWidgets.add(
//               Column(
//                 children: [
//                   Image.network(
//                     imageUrl,
//                     height: 200,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                   Text('Posted at $formattedTime'),
//                   Divider(),
//                 ],
//               ),
//             );
//           }

//           return ListView(
//             children: storyWidgets,
//           );
//         },
//       ),
//     );
//   }
// }




//new code

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class StoryPage extends StatefulWidget {
  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Upload a story to Firebase Storage and Firestore
  Future<void> uploadStory() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      try {
        // Upload image to Firebase Storage
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef = _storage.ref().child('stories/$fileName');
        await storageRef.putFile(imageFile);
        print('Image uploaded successfully');

        // Get the image URL
        String imageUrl = await storageRef.getDownloadURL();

        // Save story metadata to Firestore
        await _firestore.collection('stories').add({
          'userId': _auth.currentUser!.uid,
          'imageUrl': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        print('Story uploaded successfully');
      } catch (e) {
        print('Error uploading story: $e');
      }
    }
  }

  // Get stories that are within the last 24 hours
  Stream<QuerySnapshot> getRecentStories() {
    DateTime now = DateTime.now();
    DateTime last24Hours = now.subtract(Duration(hours: 24));

    return _firestore
        .collection('stories')
        .where('timestamp', isGreaterThan: last24Hours)
        .snapshots();
  }

  // Get user name from Firestore
  Future<String> getUserName(String userId) async {
    var userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc.data()?['name'] ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stories'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: uploadStory,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getRecentStories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final stories = snapshot.data!.docs;
          List<Widget> storyWidgets = [];

          for (var story in stories) {
            var storyData = story.data() as Map<String, dynamic>;
            var imageUrl = storyData['imageUrl'];
            var userId = storyData['userId'];
            var timestamp = (storyData['timestamp'] as Timestamp).toDate();
            var formattedTime = DateFormat('hh:mm a').format(timestamp);

            storyWidgets.add(
              FutureBuilder<String>(
                future: getUserName(userId),
                builder: (context, nameSnapshot) {
                  if (!nameSnapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Add functionality to view story when tapped
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(imageUrl),
                              backgroundColor: Colors.grey[300],
                            ),
                            SizedBox(height: 5),
                            Text(
                              nameSnapshot.data!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Posted at $formattedTime'),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            );
          }

          return SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: storyWidgets,
            ),
          );
        },
      ),
    );
  }
}
