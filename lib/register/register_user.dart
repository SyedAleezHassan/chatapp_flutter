// import 'package:chatapp_flutter/chat_page_work/main_chats.dart';
// import 'package:chatapp_flutter/main_layout_page/front_layout.dart';
// import 'package:chatapp_flutter/register/login_auth.dart';
// import 'package:chatapp_flutter/story_work_pages/mainStory.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RegistrationPage extends StatefulWidget {
//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }

// class _RegistrationPageState extends State<RegistrationPage> {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;

//   final _formKey = GlobalKey<FormState>();
//   String email = '';
//   String password = '';
//   String name = '';
//   String phoneNumber = '';

//   // Register the user and add data to Firestore
//   Future<void> registerUser() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         UserCredential userCredential =
//             await _auth.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );

//         // Add additional user details to Firestore
//         await _firestore.collection('users').doc(userCredential.user!.uid).set({
//           'name': name,
//           'email': email,
//           'phone': phoneNumber,
//           'uid': userCredential.user!.uid,
//         });

//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     tabBarPage())); // Navigate to the chat list page
//       } catch (e) {
//         print('Error: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Register'),
//         backgroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Name'),
//                 onChanged: (value) => name = value,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter your name' : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Email'),
//                 onChanged: (value) => email = value,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter your email' : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Phone Number'),
//                 onChanged: (value) => phoneNumber = value,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter your phone number' : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 onChanged: (value) => password = value,
//                 validator: (value) => value!.length < 6
//                     ? 'Password must be at least 6 characters'
//                     : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: registerUser,
//                 child: Text('Register'),
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: 25, top: 10),
//                 child: Text('Already have an account?'),
//               ),
//               TextButton(
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => LoginPage()));
//                   },
//                   child: Text('Login')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//new koudddddddd
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';

// import '../main_layout_page/front_layout.dart';
// import 'login_auth.dart';

// class RegistrationPage extends StatefulWidget {
//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }

// class _RegistrationPageState extends State<RegistrationPage> {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   final _picker = ImagePicker();
//   final _formKey = GlobalKey<FormState>();

//   String email = '';
//   String password = '';
//   String name = '';
//   String phoneNumber = '';
//   File? _selectedImage;

// // Register the user and add data to Firestore
// Future<void> registerUser() async {
//   if (_formKey.currentState!.validate()) {
//     try {
//       // Create a new user
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Get the profile photo URL
//       String photoUrl = await _getProfilePhotoUrl(userCredential.user!.uid);

//       // Add additional user details to Firestore
//       await _firestore.collection('users').doc(userCredential.user!.uid).set({
//         'name': name,
//         'email': email,
//         'phone': phoneNumber,
//         'uid': userCredential.user!.uid,
//         'photoUrl': photoUrl,
//       });

//       // Navigate to the tabBarPage after the image is uploaded and Firestore is updated
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => tabBarPage()),
//       );
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
// }

//   // Function to choose the profile photo
//   Future<String> _getProfilePhotoUrl(String userId) async {
//     String photoUrl = '';

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Select Profile Photo'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Icon(Icons.photo_library),
//               title: Text('Choose from Gallery'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 final pickedFile =
//                     await _picker.pickImage(source: ImageSource.gallery);
//                 if (pickedFile != null) {
//                   _selectedImage = File(pickedFile.path);
//                   photoUrl =
//                       await _uploadImageToFirebase(_selectedImage!, userId);
//                   setState(
//                       () {}); // Update the state after the photo is selected
//                 }
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Use Default Photo'),
//               onTap: () {
//                 // Set a default photo URL (replace with your default image URL)
//                 photoUrl = 'https://example.com/default_profile_image.png';
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );

//     return photoUrl;
//   }

//   // Function to upload the selected image to Firebase Storage and get the URL
//   Future<String> _uploadImageToFirebase(File image, String userId) async {
//     try {
//       final storageRef =
//           FirebaseStorage.instance.ref().child('profile_pics/$userId.jpg');
//       await storageRef.putFile(image);
//       return await storageRef.getDownloadURL();
//     } catch (e) {
//       print('Error uploading image: $e');
//       return 'https://example.com/default_profile_image.png'; // Use a fallback URL in case of an error
//     }
//   }

//   // Function to upload image and update Firestore with the photo URL
//   Future<void> uploadImageAndSaveToFirestore(File image, String userId) async {
//     try {
//       // Upload the image to Firebase Storage
//       final storageRef =
//           FirebaseStorage.instance.ref().child('profile_pics/$userId.jpg');
//       await storageRef.putFile(image);

//       // Get the download URL of the uploaded image
//       String downloadUrl = await storageRef.getDownloadURL();

//       // Update the Firestore database with the download URL
//       await FirebaseFirestore.instance.collection('users').doc(userId).update({
//         'photoUrl': downloadUrl,
//       });

//       print('Photo URL successfully saved to Firestore: $downloadUrl');
//     } catch (e) {
//       print(
//           '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Error uploading image or saving to Firestore: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Register'),
//         backgroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Name'),
//                 onChanged: (value) => name = value,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter your name' : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Email'),
//                 onChanged: (value) => email = value,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter your email' : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Phone Number'),
//                 onChanged: (value) => phoneNumber = value,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter your phone number' : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 onChanged: (value) => password = value,
//                 validator: (value) => value!.length < 6
//                     ? 'Password must be at least 6 characters'
//                     : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: registerUser,
//                 child: Text('Register'),
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: 25, top: 10),
//                 child: Text('Already have an account?'),
//               ),
//               TextButton(
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => LoginPage()));
//                   },
//                   child: Text('Login')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//newest code if rgisteration of the chat app in the form of circle

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';

// import '../main_layout_page/front_layout.dart';
// import 'login_auth.dart';

// class RegistrationPage extends StatefulWidget {
//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }

// class _RegistrationPageState extends State<RegistrationPage> {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   final _picker = ImagePicker();
//   final _formKey = GlobalKey<FormState>();

//   String email = '';
//   String password = '';
//   String name = '';
//   String phoneNumber = '';
//   File? _selectedImage;

// // Register the user and add data to Firestore
//   Future<void> registerUser() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         // Create a new user
//         UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );

//         // Get the profile photo URL
//         String photoUrl = await _getProfilePhotoUrl(userCredential.user!.uid);

//         // Check if the photo URL is not empty before saving
//         if (photoUrl.isNotEmpty) {
//           // Add additional user details to Firestore
//           await _firestore.collection('users').doc(userCredential.user!.uid).set({
//             'name': name,
//             'email': email,
//             'phone': phoneNumber,
//             'uid': userCredential.user!.uid,
//             'photoUrl': photoUrl,
//           });
//         }

//         // Navigate to the tabBarPage after Firestore is updated
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => tabBarPage()),
//         );
//       } catch (e) {
//         print('Error: $e');
//       }
//     }
//   }

//   // Function to choose the profile photo
//   Future<String> _getProfilePhotoUrl(String userId) async {
//     String photoUrl = '';

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Select Profile Photo'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Icon(Icons.photo_library),
//               title: Text('Choose from Gallery'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//                 if (pickedFile != null) {
//                   _selectedImage = File(pickedFile.path);
//                   photoUrl = await _uploadImageToFirebase(_selectedImage!, userId);
//                   setState(() {}); // Update the state after the photo is selected
//                 }
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Use Default Photo'),
//               onTap: () {
//                 // Set a default photo URL (replace with your default image URL)
//                 photoUrl = 'https://example.com/default_profile_image.png';
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );

//     return photoUrl;
//   }

//   // Function to upload the selected image to Firebase Storage and get the URL
//   Future<String> _uploadImageToFirebase(File image, String userId) async {
//     try {
//       final storageRef = FirebaseStorage.instance.ref().child('profile_pics/$userId.jpg');
//       await storageRef.putFile(image);
//       return await storageRef.getDownloadURL();
//     } catch (e) {
//       print('Error uploading image: $e');
//       return ''; // Return empty string in case of an error
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Register'),
//         backgroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Name'),
//                 onChanged: (value) => name = value,
//                 validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Email'),
//                 onChanged: (value) => email = value,
//                 validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Phone Number'),
//                 onChanged: (value) => phoneNumber = value,
//                 validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 onChanged: (value) => password = value,
//                 validator: (value) => value!.length < 6
//                     ? 'Password must be at least 6 characters'
//                     : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: registerUser,
//                 child: Text('Register'),
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: 25, top: 10),
//                 child: Text('Already have an account?'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
//                 },
//                 child: Text('Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// very new code

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../main_layout_page/front_layout.dart';
import 'login_auth.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String name = '';
  String phoneNumber = '';
  File? _selectedImage;

  // Register the user and add data to Firestore
  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create a new user
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Show the dialog for selecting a profile photo
        String photoUrl = await _getProfilePhotoUrl(userCredential.user!.uid);

        // Add additional user details to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'phone': phoneNumber,
          'uid': userCredential.user!.uid,
          'photoUrl': photoUrl,
        });

        // Navigate to the tabBarPage after the image is uploaded and Firestore is updated
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => tabBarPage()),
        );
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  // Function to choose the profile photo
  Future<String> _getProfilePhotoUrl(String userId) async {
    String photoUrl = '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Profile Photo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  _selectedImage = File(pickedFile.path);
                  photoUrl =
                      await _uploadImageToFirebase(_selectedImage!, userId);
                  // setState(() {}); // Update the state after the photo is selected
                }
                //yahan se syed sahab
                //           await _firestore.collection('users').add({
                //   // 'userId': _auth.currentUser!.uid,
                //   'photoUrl': photoUrl,
                //   // 'timestamp': FieldValue.serverTimestamp(),
                // });
                await _firestore
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .set({
                  'name': name,
                  'email': email,
                  'phone': phoneNumber,
                  'uid':
                      _auth.currentUser!.uid, // Add the user's UID as a field
                  'photoUrl': photoUrl,
                  // 'timestamp': FieldValue.serverTimestamp(),
                });

                //yahan tak syed sahab
                // Navigate to the tabBarPage after selecting the image
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => tabBarPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Use Default Photo'),
              onTap: () {
                // Set a default photo URL (replace with your default image URL)
                photoUrl = 'https://example.com/default_profile_image.png';
                Navigator.pop(context);

                // Navigate to the tabBarPage after using the default image
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => tabBarPage()),
                );
              },
            ),
          ],
        ),
      ),
    );

    return photoUrl;
  }

  // Function to upload the selected image to Firebase Storage and get the URL
  Future<String> _uploadImageToFirebase(File image, String userId) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_pics/$userId.jpg');
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return 'https://example.com/default_profile_image.png'; // Use a fallback URL in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your email' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                onChanged: (value) => phoneNumber = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your phone number' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) => value!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerUser,
                child: Text('Register'),
              ),
              Container(
                margin: EdgeInsets.only(left: 25, top: 10),
                child: Text('Already have an account?'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
