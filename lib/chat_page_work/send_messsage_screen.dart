// import 'package:flutter/material.dart';

// class SendMesssageScreen extends StatefulWidget {
//   final List<String> contactName;

//    SendMesssageScreen({super.key, required this.contactName});

//   @override
//   State<SendMesssageScreen> createState() => _SendMesssageScreenState();
// }

// class _SendMesssageScreenState extends State<SendMesssageScreen> {
//    List<Map<String, dynamic>> messages = [];
//   TextEditingController _messageController = TextEditingController();

//   void _sendMessage() {
//     if (_messageController.text.trim().isNotEmpty) {
//       setState(() {
//         messages.add({
//           'text': _messageController.text,
//           'isMe': true, // Indicates that this is the user's message
//         });
//       });
//       _messageController.clear();
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.contactName[0].toString()),
//       ),
//       body: Column(
//         children: [
//           // Chat message list
//           Expanded(
//             child: ListView.builder(
//               reverse: true,
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final message = messages[messages.length - 1 - index];
//                 return _buildMessageBubble(message['text'], message['isMe']);
//               },
//             ),
//           ),
//           // Text input and send button
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageBubble(String message, bool isMe) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.green[300] : Colors.grey[300],
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(15),
//             topRight: Radius.circular(15),
//             bottomLeft: isMe ? Radius.circular(15) : Radius.zero,
//             bottomRight: isMe ? Radius.zero : Radius.circular(15),
//           ),
//         ),
//         child: Text(
//           message,
//           style: TextStyle(fontSize: 16, color: Colors.black),
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageInput() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           // Message input field
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 hintText: 'Type a message',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 15),
//               ),
//             ),
//           ),
//           SizedBox(width: 10),
//           // Send button
//           CircleAvatar(
//             radius: 25,
//             backgroundColor: Colors.green,
//             child: IconButton(
//               icon: Icon(Icons.send, color: Colors.white),
//               onPressed: _sendMessage,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
///@@@@@@prev code
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ChatScreen extends StatefulWidget {
//   final String chatPartnerId;
//   final String chatPartnerName;

//   ChatScreen(this.chatPartnerId, this.chatPartnerName);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final _firestore = FirebaseFirestore.instance;
//   final _auth = FirebaseAuth.instance;
//   final TextEditingController _messageController = TextEditingController();

//   // Function to create a unique chatRoomId for each chat between two users
//   String getChatRoomId(String userId, String chatPartnerId) {
//     return userId.hashCode <= chatPartnerId.hashCode
//         ? '$userId-$chatPartnerId'
//         : '$chatPartnerId-$userId';
//   }

//   // Send a message to Firestore
//   Future<void> sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       String chatRoomId = getChatRoomId(_auth.currentUser!.uid, widget.chatPartnerId);

//       await _firestore.collection('chats').doc(chatRoomId).collection('messages').add({
//         'sender': _auth.currentUser!.uid,
//         'receiver': widget.chatPartnerId,
//         'text': _messageController.text,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.chatPartnerName),
//         backgroundColor: Colors.black,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('chats')
//                   .doc(getChatRoomId(_auth.currentUser!.uid, widget.chatPartnerId))
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 final messages = snapshot.data!.docs;
//                 List<Widget> messageWidgets = [];
//                 for (var message in messages) {
//                   var messageData = message.data() as Map<String, dynamic>;
//                   var isMe = messageData['sender'] == _auth.currentUser!.uid;
//                   messageWidgets.add(
//                     Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         padding: EdgeInsets.all(10),
//                         margin: EdgeInsets.all(5),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.green : Colors.grey[700],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           messageData['text'],
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   );
//                 }

//                 return ListView(
//                   reverse: true,
//                   children: messageWidgets,
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(hintText: 'Enter message...'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.green),
//                   onPressed: sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//@@@new code video call k sath wala

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart'; // For formatting date and time

// class ChatScreen extends StatefulWidget {
//   final String chatPartnerId;
//   final String chatPartnerName;

//   ChatScreen(this.chatPartnerId, this.chatPartnerName);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final _firestore = FirebaseFirestore.instance;
//   final _auth = FirebaseAuth.instance;
//   final TextEditingController _messageController = TextEditingController();

//   // Function to create a unique chatRoomId for each chat between two users
//   String getChatRoomId(String userId, String chatPartnerId) {
//     return userId.hashCode <= chatPartnerId.hashCode
//         ? '$userId-$chatPartnerId'
//         : '$chatPartnerId-$userId';
//   }

// //new send message func
// Future<void> sendMessage() async {
//   if (_messageController.text.isNotEmpty) {
//     String chatRoomId = getChatRoomId(_auth.currentUser!.uid, widget.chatPartnerId);

//     // Send message with 'unread' status
//     await _firestore.collection('chats').doc(chatRoomId).collection('messages').add({
//       'sender': _auth.currentUser!.uid,
//       'receiver': widget.chatPartnerId,
//       'text': _messageController.text,
//       'timestamp': FieldValue.serverTimestamp(),
//       'unread': true,
//     });

//     // Update the chat room's last message details and increment the unread count for the receiver
//     await _firestore.collection('chats').doc(chatRoomId).set({
//       'lastMessage': _messageController.text,
//       'lastMessageTimestamp': FieldValue.serverTimestamp(),
//       'unreadCount_${widget.chatPartnerId}': FieldValue.increment(1),
//     }, SetOptions(merge: true));

//     _messageController.clear();
//   }
// }

//   // Simulate starting a voice call
//   Future<void> startVoiceCall() async {
//     await saveCallToFirestore('voice');
//     // Integrate voice call API here (e.g., Agora, Twilio)
//     print('Voice call started with ${widget.chatPartnerName}');
//   }

//   // Simulate starting a video call
//   Future<void> startVideoCall() async {
//     await saveCallToFirestore('video');
//     // Integrate video call API here (e.g., Agora, Twilio)
//     print('Video call started with ${widget.chatPartnerName}');
//   }

//   // Save the call details to Firestore
//   Future<void> saveCallToFirestore(String callType) async {
//     await _firestore.collection('calls').add({
//       'caller': _auth.currentUser!.uid,
//       'receiver': widget.chatPartnerId,
//       'callType': callType, // 'voice' or 'video'
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }
//   //

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.chatPartnerName),
//         backgroundColor: Colors.black,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.call),
//             onPressed: startVoiceCall, // Start voice call
//           ),
//           IconButton(
//             icon: Icon(Icons.videocam),
//             onPressed: startVideoCall, // Start video call
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('chats')
//                   .doc(getChatRoomId(_auth.currentUser!.uid, widget.chatPartnerId))
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 final messages = snapshot.data!.docs;
//                 List<Widget> messageWidgets = [];
//                 for (var message in messages) {
//                   var messageData = message.data() as Map<String, dynamic>;
//                   var isMe = messageData['sender'] == _auth.currentUser!.uid;
//                   messageWidgets.add(
//                     Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         padding: EdgeInsets.all(10),
//                         margin: EdgeInsets.all(5),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.green : Colors.grey[700],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           messageData['text'],
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   );
//                 }

//                 return ListView(
//                   reverse: true,
//                   children: messageWidgets,
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(hintText: 'Enter message...'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.green),
//                   onPressed: sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String chatPartnerId;
  final String chatPartnerName;

  ChatScreen(this.chatPartnerId, this.chatPartnerName);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();

  String getChatRoomId(String userId, String chatPartnerId) {
    return userId.hashCode <= chatPartnerId.hashCode
        ? '$userId-$chatPartnerId'
        : '$chatPartnerId-$userId';
  }

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String chatRoomId =
          getChatRoomId(_auth.currentUser!.uid, widget.chatPartnerId);

      await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'sender': _auth.currentUser!.uid,
        'receiver': widget.chatPartnerId,
        'text': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'unread': true,
      });

      await _firestore.collection('chats').doc(chatRoomId).set({
        'lastMessage': _messageController.text,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
        'unreadCount_${widget.chatPartnerId}': FieldValue.increment(1),
      }, SetOptions(merge: true));

      _messageController.clear();
    }
  }

  // Future<void> startVoiceCall() async {
  //   await saveCallToFirestore('voice');
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CallScreen(
  //         receiverName: widget.chatPartnerName,
  //         receiverId: widget.chatPartnerId,
  //       ),
  //     ),
  //   );
  // }

// Future<void> startVoiceCall() async {
//   await saveCallToFirestore('voice');

//   // Simulating showing a dialog to the receiver
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return AlertDialog(
//         title: Text('Incoming Call'),
//         content: Text('${widget.chatPartnerName} is calling you'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cut Call'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               // For now, this doesn't have any functionality
//               print('Receive Call tapped');
//             },
//             child: Text('Receive'),
//           ),
//         ],
//       );
//     },
//   );

//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => CallScreen(
//         receiverName: widget.chatPartnerName,
//         receiverId: widget.chatPartnerId,
//       ),
//     ),
//   );
// }

  Future<void> startVoiceCall() async {
    final String callId = _firestore
        .collection('active_calls')
        .doc()
        .id; // Generate a unique call ID

    // Add the call document to Firestore
    await _firestore.collection('active_calls').doc(callId).set({
      'caller': _auth.currentUser!.uid,
      'receiver': widget.chatPartnerId,
      'callType': 'voice',
      'status': 'calling',
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallScreen(
          receiverName: widget.chatPartnerName,
          receiverId: widget.chatPartnerId,
          callId: callId,
        ),
      ),
    );
  }

  Future<void> saveCallToFirestore(String callType) async {
    await _firestore.collection('calls').add({
      'caller': _auth.currentUser!.uid,
      'receiver': widget.chatPartnerId,
      'callType': callType,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void listenForIncomingCalls() {
    final String currentUserId = _auth.currentUser!.uid;

    _firestore
        .collection('active_calls')
        .where('receiver', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'calling')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var callData = snapshot.docs.first.data();
        String callerId = callData['caller'];
        String callId = snapshot.docs.first.id;

        // Show the dialog when a call is detected
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('Incoming Call'),
              content: Text('User $callerId is calling you'),
              actions: [
                TextButton(
                  onPressed: () {
                    // Update the call status to ended
                    _firestore.collection('active_calls').doc(callId).update({
                      'status': 'ended',
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Cut Call'),
                ),
                TextButton(
                  onPressed: () {
                    // Update the call status to accepted
                    _firestore.collection('active_calls').doc(callId).update({
                      'status': 'accepted',
                    });
                    Navigator.of(context).pop();
                    // Add receive functionality here in the future
                  },
                  child: Text('Receive'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatPartnerName),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: startVoiceCall,
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {}, // Start video call
          ),
        ],
      ),

      ///////////
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(getChatRoomId(
                      _auth.currentUser!.uid, widget.chatPartnerId))
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  var messageData = message.data() as Map<String, dynamic>;
                  var isMe = messageData['sender'] == _auth.currentUser!.uid;
                  messageWidgets.add(
                    Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.green : Colors.grey[700],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          messageData['text'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }

                return ListView(
                  reverse: true,
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Enter message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),

///////////////
      // Rest of the ChatScreen code remains the same
      // ...
    );
  }
}

// CallScreen Component
class CallScreen extends StatelessWidget {
  final String receiverName;
  final String receiverId;

  CallScreen(
      {required this.receiverName,
      required this.receiverId,
      required String callId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calling $receiverName'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Voice Call with $receiverName',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.call_end),
              label: Text('Cut Call'),
              style: ElevatedButton.styleFrom(iconColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
