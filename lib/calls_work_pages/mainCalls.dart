import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class mainCalls extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  // Widget build(BuildContext context) {
  //   String currentUserId = _auth.currentUser!.uid;

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Calls'),
  //       backgroundColor: Colors.black,
  //     ),
  //     body: StreamBuilder<QuerySnapshot>(
  //       stream: _firestore
  //           .collection('active_calls')
  //           .where('caller', isEqualTo: currentUserId)
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(child: CircularProgressIndicator());
  //         }

  //         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //           return Center(child: Text('No calls found.'));
  //         }

  //         List<QueryDocumentSnapshot> outgoingCalls = snapshot.data!.docs;

  //         return FutureBuilder<QuerySnapshot>(
  //           future: _firestore
  //               .collection('calls')
  //               .where('receiver', isEqualTo: currentUserId)
  //               .get(),
  //           builder: (context, incomingSnapshot) {
  //             if (incomingSnapshot.connectionState == ConnectionState.waiting) {
  //               return Center(child: CircularProgressIndicator());
  //             }

  //             List<QueryDocumentSnapshot> calls = [...outgoingCalls];
  //             if (incomingSnapshot.hasData) {
  //               calls.addAll(incomingSnapshot.data!.docs);
  //             }

  //             return ListView.builder(
  //               itemCount: calls.length,
  //               itemBuilder: (context, index) {
  //                 var call = calls[index].data() as Map<String, dynamic>;
  //                 String callType = call['callType'];
  //                 String caller = call['caller'];
  //                 String receiver = call['receiver'];
  //                 Timestamp timestamp = call['timestamp'];

  //                 // Fetch receiver details from Firestore
  //                 return FutureBuilder<DocumentSnapshot>(
  //                   future: _firestore.collection('users').doc(receiver).get(),
  //                   builder: (context, userSnapshot) {
  //                     if (userSnapshot.connectionState ==
  //                         ConnectionState.waiting) {
  //                       return ListTile(
  //                         leading: CircleAvatar(
  //                           backgroundColor: Colors.grey,
  //                         ),
  //                         title: Text('Loading...'),
  //                         subtitle: Text(''),
  //                       );
  //                     }

  //                     if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
  //                       return ListTile(
  //                         leading: CircleAvatar(
  //                           backgroundColor: Colors.grey,
  //                         ),
  //                         title: Text('User not found'),
  //                         subtitle: Text(''),
  //                       );
  //                     }

  //                     var receiverData =
  //                         userSnapshot.data!.data() as Map<String, dynamic>;
  //                     String receiverName = receiverData['name'];
  //                     String receiverPhotoUrl = receiverData['photoUrl'];

  //                     return ListTile(
  //                       leading: CircleAvatar(
  //                         backgroundImage: NetworkImage(receiverPhotoUrl),
  //                       ),
  //                       title: Text(receiverName),
  //                       subtitle: Text(
  //                           '${callType == 'outgoing' ? 'Outgoing' : 'Incoming'} Call - ${timestamp.toDate()}'),
  //                       onTap: () {
  //                         // Implement call details or other action when tapped
  //                       },
  //                     );
  //                   },
  //                 );
  //               },
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

//chatgpt wal deisgn

  Widget build(BuildContext context) {
    String currentUserId = _auth.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text(
      //     'Calls',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: Colors.black,
      //   elevation: 0,
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('active_calls')
            .where('caller', isEqualTo: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No calls found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          List<QueryDocumentSnapshot> outgoingCalls = snapshot.data!.docs;

          return FutureBuilder<QuerySnapshot>(
            future: _firestore
                .collection('active_calls')
                .where('receiver', isEqualTo: currentUserId)
                .get(),
            builder: (context, incomingSnapshot) {
              if (incomingSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              List<QueryDocumentSnapshot> calls = [...outgoingCalls];
              if (incomingSnapshot.hasData) {
                calls.addAll(incomingSnapshot.data!.docs);
              }

              return ListView.builder(
                itemCount: calls.length,
                itemBuilder: (context, index) {
                  var call = calls[index].data() as Map<String, dynamic>;
                  String callType = call['callType'];
                  String caller = call['caller'];
                  String receiver = call['receiver'];
                  Timestamp timestamp = call['timestamp'];

                  return FutureBuilder<DocumentSnapshot>(
                    future: _firestore.collection('users').doc(receiver).get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[800],
                          ),
                          title: Text(
                            'Loading...',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(''),
                        );
                      }

                      if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[800],
                          ),
                          title: Text(
                            'User not found',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(''),
                        );
                      }

                      var receiverData =
                          userSnapshot.data!.data() as Map<String, dynamic>;
                      String receiverName = receiverData['name'];
                      String receiverPhotoUrl = receiverData['photoUrl'];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(receiverPhotoUrl),
                          backgroundColor: Colors.grey[800],
                        ),
                        title: Text(
                          receiverName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${callType == 'outgoing' ? 'Outgoing' : 'Incoming'} Call - ${timestamp.toDate()}',
                          style: TextStyle(color: Colors.white70),
                        ),
                        onTap: () {
                          // Implement call details or other action when tapped
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
//end
}
