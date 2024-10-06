import 'package:flutter/material.dart';

class mainStory extends StatelessWidget {
  // Sample stories list
  final List<Map<String, String>> stories = [
    {
      'username': 'John',
      'imageUrl': 'https://via.placeholder.com/150', // Placeholder image URL
    },
    {
      'username': 'Emily',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'username': 'Alex',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'username': 'Sophia',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'username': 'Michael',
      'imageUrl': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black, // Black theme background
      // appBar: AppBar(
      //   title: Text('Stories'),
      //   backgroundColor: Colors.black, // Black theme app bar
      //   elevation: 0,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Display "My Story" at the top
            _buildMyStory(),
            SizedBox(height: 20),
            // List of other stories
            Expanded(child: _buildStoryList()),
          ],
        ),
      ),
    );
  }

  // Build "My Story" section
  Widget _buildMyStory() {
    return Row(
      children: [
        // My story profile picture
        CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(
              'https://via.placeholder.com/150'), // Replace with actual image
        ),
        SizedBox(width: 15),
        // My story description
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Story',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 5),
            Text(
              'Add to my story',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  // Build the list of stories
  Widget _buildStoryList() {
    return ListView.builder(
      itemCount: stories.length,
      itemBuilder: (context, index) {
        return _buildStoryItem(
            stories[index]['username']!, stories[index]['imageUrl']!);
      },
    );
  }

  // Build each story item in the list
  Widget _buildStoryItem(String username, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          // Story profile picture
          CircleAvatar(
            radius: 35,
            backgroundImage:
                NetworkImage(imageUrl), // Replace with actual image URL
          ),
          SizedBox(width: 15),
          // Username next to the profile picture
          Text(
            username,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
