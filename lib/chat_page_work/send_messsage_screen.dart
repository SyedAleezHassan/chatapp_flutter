
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
  @override
  void initState() {
    super.initState();
    listenForIncomingCalls();
  }

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
      _messageController.clear();
      await _firestore.collection('chats').doc(chatRoomId).set({
        'lastMessage': _messageController.text,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
        'unreadCount_${widget.chatPartnerId}': FieldValue.increment(1),
      }, SetOptions(merge: true));
    }
  }

  

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

 

  void listenForIncomingCalls() {
    final String currentUserId = _auth.currentUser!.uid;

    _firestore
        .collection('active_calls')
        .where('receiver', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'calling')
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        var callData = snapshot.docs.first.data();
        String callerId = callData['caller'];
        String callId = snapshot.docs.first.id;

        // Fetch the caller's name using the callerId
        DocumentSnapshot callerSnapshot =
            await _firestore.collection('users').doc(callerId).get();

        if (callerSnapshot.exists) {
          var callerData = callerSnapshot.data() as Map<String, dynamic>;
          String callerName = callerData['name'] ?? 'Unknown User';

          // Show the notification-like dialog when a call is detected
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Stack(
                children: [
                  Positioned(
                    top: 50.0,
                    left: 20.0,
                    right: 20.0,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$callerName is calling...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Reject Call Button
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(20),
                                  ),
                                  onPressed: () {
                                    // Update the call status to ended
                                    _firestore
                                        .collection('active_calls')
                                        .doc(callId)
                                        .update({'status': 'ended'});
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.call_end,
                                    color: Colors.white,
                                  ),
                                ),
                                // Accept Call Button
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(20),
                                  ),
                                  onPressed: () {
                                    // Update the call status to accepted
                                    _firestore
                                        .collection('active_calls')
                                        .doc(callId)
                                        .update({'status': 'accepted'});
                                    Navigator.of(context).pop();
                                    // Add receive functionality here in the future
                                  },
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  @override


//chatgpt wala start
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white), // Set the back arrow color to white
        title: Text(
          widget.chatPartnerName,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        shape: Border(
          bottom: BorderSide(
              color: Colors.white,
              width: 2), // Add a white border at the bottom
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: Colors.white),
            onPressed: startVoiceCall,
          ),
          IconButton(
            icon: Icon(Icons.videocam, color: Colors.white),
            onPressed: () {}, // Start video call
          ),
        ],
      ),

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
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
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
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.white : Colors.grey[800],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey[600]!),
                        ),
                        child: Text(
                          messageData['text'],
                          style: TextStyle(
                            color: isMe ? Colors.black : Colors.white,
                            fontSize: 14,
                          ),
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
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter message...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[850],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //endddd
}

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
        title: Text(
          'Calling $receiverName',
          style: TextStyle(color: Colors.white), // White text for app bar
        ),
        backgroundColor: Colors.black, // Black app bar
      ),
      backgroundColor: Colors.black, // Black background for the body
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Voice Call with $receiverName',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white, // White text for receiver name
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            bottom: 50, // Position the button near the bottom
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.call_end),
                label: Text('Cut Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red button background
                  foregroundColor: Colors.white, // White text and icon
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0), // Rounded button
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
