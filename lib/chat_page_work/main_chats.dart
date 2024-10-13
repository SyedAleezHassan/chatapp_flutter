// import 'package:chatapp_flutter/colors.dart';
// import 'package:flutter/material.dart';

// import 'send_messsage_screen.dart';

// List<Map<dynamic, dynamic>> chatList = [
//   {"name": 'Khuala', 'num': 03323817281}
// ];
// TextEditingController nameController = TextEditingController();
// TextEditingController numController = TextEditingController();
// class mainChat extends StatefulWidget {
//   const mainChat({super.key});

//   @override
//   State<mainChat> createState() => _mainChatState();
// }

// class _mainChatState extends State<mainChat> {
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
//                           builder: (context) => SendMesssageScreen(contactName: [chatList[index]['name']],)));
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

            userTiles.add(ListTile(
              leading: CircleAvatar(
                backgroundImage: userData['photoUrl'] != null
                    ? NetworkImage(userData['photoUrl'])
                    : AssetImage('assets/default_profile.png') as ImageProvider,
              ),
              title: Text(userData['name']),
              subtitle: Text(userData['phone']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(userData['uid'], userData['name']),
                  ),
                );
              },
            ));
          }

          return ListView(children: userTiles);
        },
      ),
    );
  }
}
