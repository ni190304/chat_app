import 'package:chat_app/api/apis.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/profile.dart';
import 'package:chat_app/widgets/chat_user_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  List<ChatUser> list = [];

  final List<ChatUser> searlist = [];
  bool is_searching = false;

  @override
  void initState() {
    super.initState();
    Reference.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: !is_searching,
        onPopInvoked: (_) async {
          if (is_searching) {
            setState(() => is_searching = !is_searching);
          } else {
            Navigator.of(context).pop();
          }
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: is_searching
                  ? TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Name, Email'),
                      autofocus: true,
                      style: TextStyle(fontSize: 17, letterSpacing: 0.5),
                      onChanged: (val) {
                        searlist.clear();

                        for (var i in list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            searlist.add(i);
                          }
                          setState(() {
                            searlist;
                          });
                        }
                      },
                    )
                  : const Text('Buzz Chat   💬', style: TextStyle(color: Color.fromARGB(255, 54, 20, 61), fontSize: 25),),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        is_searching = !is_searching;
                      });
                    },
                    icon: Icon(is_searching
                        ? CupertinoIcons.clear_circled
                        : Icons.search)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Profile_Screen(
                                    user: Reference.me,
                                  )));
                    },
                    icon: const Icon(Icons.more_vert))
              ],
            ),
            body: StreamBuilder(
              stream: Reference.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list = data
                            ?.map((e) => ChatUser.fromJson(e.data()))
                            .toList() ??
                        [];

                    if (list.isNotEmpty) {
                      return ListView.builder(
                        itemCount: is_searching
                            ? searlist.length
                            : list
                                .length, // Set itemCount to the length of the list
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                            user: is_searching ? searlist[index] : list[index],
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'No Connections found',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
