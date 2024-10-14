// import 'package:chatapp_flutter/colors.dart';
// import 'package:flutter/material.dart';

// import 'send_messsage_screen.dart';

// List<Map<dynamic, dynamic>> chatList = [
//   {"name": 'Khuala', 'num': 03323817281}
// ];
// TextEditingController nameController = TextEditingController();
// TextEditingController numController = TextEditingController();

// class ChatListPage extends StatefulWidget {
//   const ChatListPage({super.key});

//   @override
//   State<ChatListPage> createState() => ChatListPage();
// }

// class ChatListPage extends State<ChatListPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//           itemCount: chatList.length,
//           itemBuilder: (context, index) {
//             return Container(
//               margin: EdgeInsets.only(bottom: 7),
//               decoration: BoxDecoration(
//                 color: appColor.secondaryColor, // Background color for the tile
//                 border: Border.all(
//                   color: Colors.black, // Border color
//                   width: 2.0, // Border thickness
//                 ),
//                 borderRadius: BorderRadius.circular(10), // Rounded corners
//               ),
//               child: ListTile(
//                 title: Text(
//                   chatList[index]['name'],
//                   style: TextStyle(
//                     color: Colors.black, // Text color
//                     fontWeight: FontWeight.bold, // Bold text for chat names
//                   ),
//                 ),
//                 subtitle: Text(
//                   'Last message here...',
//                   style: TextStyle(
//                     color: Colors.grey,
//                   ),
//                 ),
//                 leading: CircleAvatar(
//                     // backgroundImage: NetworkImage(
//                     //     chatList[index]['profilePic']), // Chat profile picture
//                     ),
//                 trailing: Text(
//                   '10:30 AM',
//                   style: TextStyle(
//                     color: Colors.black54,
//                   ),
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               ChatScreen(userData['uid'], userData['name'])));
//                 },
//               ),
//             );
//           }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showAddContactDialog(context);
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   void _showAddContactDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Add Contact'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Name',
//                 ),
//               ),
//               TextField(
//                 controller: numController,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone Number',
//                 ),
//                 keyboardType: TextInputType.phone,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Handle saving contact here (e.g., storing in a list or database)
//                 String name = nameController.text;
//                 String number = numController.text;

//                 // print('Contact saved: Name = $name, Number = $number');
//                 setState(() {
//                   chatList.add({
//                     'name': name,
//                     'num': num.parse.toString(),
//                   });
//                 });
//                 print(chatList);

//                 // Clear the fields and close the dialog
//                 nameController.clear();
//                 numController.clear();

//                 Navigator.of(context).pop();
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

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
                if (!chatSnapshot.hasData) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: userData['photoUrl'] != null
                          ? NetworkImage(userData['photoUrl'])
                          : AssetImage('assets/default_profile.png')
                              as ImageProvider,
                    ),
                    title: Text(userData['name']),
                    subtitle: Text(userData['phone']),
                    onTap: () {
                      print('Tile tapped for ${userData['name']}');
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
                }

                var chatData =
                    chatSnapshot.data?.data() as Map<String, dynamic>?;
                String lastMessage = chatData?['lastMessage'] ?? '';
                int unreadCount =
                    chatData?['unreadCount_${currentUser.uid}'] ?? 0;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: userData['photoUrl'] != null
                        ? NetworkImage(userData['photoUrl'])
                        : AssetImage('assets/default_profile.png')
                            as ImageProvider,
                  ),
                  title: Text(
                    userData['name'],
                    style: TextStyle(
                      fontWeight:
                          unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lastMessage,
                        style: TextStyle(
                          fontWeight: unreadCount > 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (unreadCount > 0)
                        Text(
                          '$unreadCount unread message(s)',
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
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
              },
            ));
          }

          return ListView(children: userTiles);
        },
      ),
    );
  }

  String getChatRoomId(String userId, String chatPartnerId) {
    return userId.hashCode <= chatPartnerId.hashCode
        ? '$userId-$chatPartnerId'
        : '$chatPartnerId-$userId';
  }
}
