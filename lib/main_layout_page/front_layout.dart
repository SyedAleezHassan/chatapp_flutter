import 'package:chatapp_flutter/colors.dart';
import 'package:flutter/material.dart';

import '../calls_work_pages/mainCalls.dart';
import '../chat_page_work/main_chats.dart';
import '../story_work_pages/mainStory.dart';

class tabBarPage extends StatefulWidget {
  const tabBarPage({super.key});

  @override
  State<tabBarPage> createState() => _tabBarPageState();
}

class _tabBarPageState extends State<tabBarPage> {
  @override
  // Widget build(BuildContext context) {
  //   return DefaultTabController(
  //       length: 3,
  //       child: Scaffold(
  //         appBar: AppBar(
  //           backgroundColor: appColor.primaryColor,
  //           title: const Text(
  //             'Aleez Chat App',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           bottom: const TabBar(
  //             labelColor: Colors.white, // Color of the selected tab
  //             unselectedLabelColor:
  //                 Colors.white70, // Color of the unselected tabs
  //             indicatorColor: Colors.white,
  //             tabs: [
  //               Tab(
  //                 text: 'Chats',
  //               ),
  //               Tab(
  //                 text: 'Story',
  //               ),
  //               Tab(
  //                 text: 'Calls',
  //               ),
  //             ],
  //           ),
  //         ),
  //         body: TabBarView(children: [
  //           ChatListPage(),
  //           StoryPage(),
  //           mainCalls(),
  //         ]),
  //       ));
  // }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              Colors.black, // Set the AppBar background color to black
          title: const Text(
            'Aleez Chat App',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold, // Make the title bold
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.white, // Color of the selected tab
            unselectedLabelColor: Colors.grey, // Color of the unselected tabs
            indicatorColor:
                Colors.white, // Color of the indicator for the selected tab
            indicatorWeight: 3.0, // Make the indicator thicker for emphasis
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold, // Make tab text bold
              fontSize: 16, // Slightly increase the font size for tabs
            ),
            tabs: [
              Tab(
                text: 'Chats',
              ),
              Tab(
                text: 'Story',
              ),
              Tab(
                text: 'Calls',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChatListPage(),
            StoryPage(),
            mainCalls(),
          ],
        ),
      ),
    );
  }
}
