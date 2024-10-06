import 'package:chatapp_flutter/chat_page_work/main_chats.dart';
import 'package:chatapp_flutter/main_layout_page/front_layout.dart';
import 'package:chatapp_flutter/register/login_auth.dart';
import 'package:chatapp_flutter/story_work_pages/mainStory.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';
  String phoneNumber = '';

  // Register the user and add data to Firestore
  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Add additional user details to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'phone': phoneNumber,
          'uid': userCredential.user!.uid,
        });

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    tabBarPage())); // Navigate to the chat list page
      } catch (e) {
        print('Error: $e');
      }
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
