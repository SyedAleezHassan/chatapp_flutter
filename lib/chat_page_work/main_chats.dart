import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'send_messsage_screen.dart';

class ChatListPage extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;
          List<Widget> userTiles = [];
          final currentUser = FirebaseAuth.instance.currentUser;

          for (var user in users) {
            var userData = user.data() as Map<String, dynamic>;

            // Skip the current user's tile
            if (userData['uid'] == currentUser?.uid) {
              continue;
            }

            userTiles.add(StreamBuilder<DocumentSnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(getChatRoomId(currentUser!.uid, userData['uid']))
                  .snapshots(),
              builder: (context, chatSnapshot) {
                if (!chatSnapshot.hasData) {}

                var chatData =
                    chatSnapshot.data?.data() as Map<String, dynamic>?;
                String lastMessage = chatData?['lastMessage'] ?? '';
                int unreadCount =
                    chatData?['unreadCount_${currentUser.uid}'] ?? 0;

                //design
                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: userData['photoUrl'] != null &&
                            userData['photoUrl'].isNotEmpty
                        ? NetworkImage(userData['photoUrl'])
                        : null,
                    child: userData['photoUrl'] == null ||
                            userData['photoUrl'].isEmpty
                        ? Icon(Icons.person, size: 24, color: Colors.grey[600])
                        : null,
                  ),
                  title: Text(
                    userData['name'],
                    style: TextStyle(
                      fontWeight:
                          unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14.0,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lastMessage,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: unreadCount > 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (unreadCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '$unreadCount unread message(s)',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                    ],
                  ),
                  tileColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.grey[300]!, width: 1.0),
                  ),
                  selectedColor: Colors.black26,
                  // elevation: 2,
                  onTap: () {
                    print('Navigating to chat screen for ${userData['name']}');

                    // Reset unread count for the chat room
                    _firestore
                        .collection('chats')
                        .doc(getChatRoomId(currentUser.uid, userData['uid']))
                        .update({
                      'unreadCount_${currentUser.uid}': 0,
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          userData['uid'],
                          userData['name'],
                        ),
                      ),
                    );
                  },
                );

                //endddd
              },
            ));
          }

          return ListView(children: userTiles);
        },
      ),
    );
  }

//enddddddddddddd
  String getChatRoomId(String userId, String chatPartnerId) {
    return userId.hashCode <= chatPartnerId.hashCode
        ? '$userId-$chatPartnerId'
        : '$chatPartnerId-$userId';
  }
}
