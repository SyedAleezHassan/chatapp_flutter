import 'package:flutter/material.dart';

class mainCalls extends StatelessWidget {
  // Sample list of call logs
  final List<Map<String, dynamic>> callLogs = [
    {
      'name': 'John',
      'time': 'Today, 2:30 PM',
      'callType': 'voice', // 'voice' or 'video'
      'status': 'received', // 'missed', 'received', 'outgoing'
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Emily',
      'time': 'Yesterday, 5:15 PM',
      'callType': 'video',
      'status': 'missed',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Alex',
      'time': 'Yesterday, 3:00 PM',
      'callType': 'voice',
      'status': 'outgoing',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Sophia',
      'time': 'Today, 10:00 AM',
      'callType': 'video',
      'status': 'received',
      'imageUrl': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background to black
      body: ListView.builder(
        itemCount: callLogs.length,
        itemBuilder: (context, index) {
          return _buildCallItem(
            callLogs[index]['name'],
            callLogs[index]['time'],
            callLogs[index]['callType'],
            callLogs[index]['status'],
            callLogs[index]['imageUrl'],
          );
        },
      ),
    );
  }

  // Build each call log item
  Widget _buildCallItem(String name, String time, String callType, String status, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Row(
        children: [
          // Profile picture
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl), // Replace with real image URL
          ),
          SizedBox(width: 15),
          // Name and time column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle (fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    // Call status icon (missed, received, outgoing)
                    Icon(
                      _getStatusIcon(status),
                      color: _getStatusColor(status),
                      size: 16,
                    ),
                    SizedBox(width: 5),
                    // Call time
                    Text(
                      time,
                      style: TextStyle( fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Call type icon (voice or video)
          Icon(
            callType == 'voice' ? Icons.phone : Icons.videocam,
            color: Colors.greenAccent,
          ),
        ],
      ),
    );
  }

  // Get the appropriate status icon for the call
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'missed':
        return Icons.call_missed;
      case 'outgoing':
        return Icons.call_made;
      case 'received':
        return Icons.call_received;
      default:
        return Icons.call;
    }
  }

  // Get the color for the call status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'missed':
        return Colors.redAccent;
      case 'outgoing':
        return Colors.greenAccent;
      case 'received':
        return Colors.greenAccent;
      default:
        return Colors.black;
    }
  }
}
