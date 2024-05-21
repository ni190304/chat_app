import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/my_date_util.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/screens/chatscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? message;

  @override
  Widget build(BuildContext context) {
    // Ensure MediaQuery is properly initialized

    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0.4,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
              stream: Reference.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;

                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (list.isNotEmpty) message = list[0];

                return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * 0.3),
                      child: CachedNetworkImage(
                        width: mq.height * 0.055,
                        height: mq.height * 0.055,
                        imageUrl: widget.user.image,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(), // Loading indicator
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(widget.user.name),
                    subtitle: Text(
                      message != null ? message!.msg : widget.user.about,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: message == null
                        ? null
                        : message!.read.isEmpty &&
                                message!.fromId != Reference.users.uid
                            ? Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: Colors.greenAccent.shade400,
                                    borderRadius: BorderRadius.circular(10)),
                              )
                            : Text(
                                MyDateUtil.getLastMessageTime(
                                    context: context, time: message!.sent),
                                style: TextStyle(color: Colors.black54),
                              ));
              })),
    );
  }
}
