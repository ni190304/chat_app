import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Reference {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore fire = FirebaseFirestore.instance;

  static User get users => auth.currentUser!;

  static late ChatUser me;

  static Future<bool> userExists() async {
    return (await fire.collection('users').doc(users.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    await fire.collection('users').doc(users.uid).get().then((users) async {
      if (users.exists) {
        me = ChatUser.fromJson(users.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        image: users.photoURL.toString(),
        name: users.displayName.toString(),
        about: 'Hey , I am using BuzzChat',
        createdAt: time,
        id: auth.currentUser!.uid,
        lastActive: time,
        isOnline: false,
        pushToken: '',
        email: users.email.toString());

    return await fire.collection('users').doc(users.uid).set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return fire
        .collection('users')
        .where('id', isNotEqualTo: users.uid)
        .snapshots();
  }

  static Future<void> updateInfo() async {
    await fire
        .collection('users')
        .doc(users.uid)
        .update({'name': me.name, 'about': me.about});
  }

  static String getConversationId(String id) =>
      users.uid.hashCode <= id.hashCode
          ? '${users.uid}_$id'
          : '${id}_${users.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return fire
        .collection('chats/${getConversationId(user.id)}/messages/')
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser user, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        msg: msg,
        toId: user.id,
        read: '',
        type: Type.text,
        sent: time,
        fromId: users.uid);

    final ref =
        fire.collection('chats/${getConversationId(user.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updatemessagereadstatus(Message message) async {
    fire
        .collection('chats/${getConversationId(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return fire
        .collection('chats/${getConversationId(user.id)}/messages/').
        orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
}
