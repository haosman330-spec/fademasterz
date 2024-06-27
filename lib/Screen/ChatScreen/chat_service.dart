import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_user_sendmessage_modal.dart';
import 'chat_usermodel.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class ChatService {
  dynamic time;
  int value = 0;

  int unreadCount = 0;
  static Future<void> getSelfInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? currentUserId = sharedPreferences.getInt('senderId').toString();
    await firestore
        .collection('users')
        .doc(
          currentUserId,
        )
        .get()
        .then((user) async {
      if (user.exists) {
        // APIs.updateActiveStatus(true);
        updateUserInfo();
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    var fcm = sharedPreferences.getString('fcmToken');
    String? currentUserId = sharedPreferences.getInt('senderId').toString();
    final chatuser = ChatUser(
      id: currentUserId,
      pushToken: fcm.toString(),
      lastmessage: '',
      status: '',
      image: '',
      name: '',
      about: '',
      createdAt: '',
      isOnline: '',
      lastActive: '',
      email: '',
    );
    await firestore
        .collection('users')
        .doc(currentUserId)
        .set(chatuser.toJson());
  }

  static Future<void> updateUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? currentUserId = sharedPreferences.getInt('senderId').toString();
    var image = sharedPreferences.getString("user_Image");
    var userName = sharedPreferences.getString('user_Name');
    var fcm = sharedPreferences.getString('fcmToken');

    await firestore
        .collection('users')
        .doc(
          currentUserId,
        )
        .update({
      'name': userName,
      "image": image,
      'is_online': "Online",
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': fcm,
    });
  }

  Future<void> sendMessage({
    required String receiverId,
    required String message,
    required String? receiverImage,
    required String? receiverName,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? currentUserId = sharedPreferences.getInt('senderId').toString();
    String? currentUserEmail = sharedPreferences.getString('email');
    // final Timestamp timestamp = Timestamp.now();
    time = DateTime.now().millisecondsSinceEpoch.toString();

    Messages messages = Messages(
      senderId: currentUserId.toString(),
      senderEmail: currentUserEmail.toString(),
      receiverId: receiverId,
      message: message,
      image: sharedPreferences.getString('image'),
      readBy: [],
      timestamp: int.parse(time),
      fcmToken: sharedPreferences.getString('fcmToken'),
    );
    List<String> ids = [currentUserId.toString(), receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    await firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(messages.toMap());

    await firestore.collection('chat_rooms').doc(chatRoomId).set({
      "chat_id": chatRoomId,
      "last_message_time": int.parse(time),
      "last_message": message,
      "sender_id": currentUserId,
      "image": sharedPreferences.getString('image'),
      "members": [currentUserId, receiverId],
      "members_list": [
        {
          "image": sharedPreferences.getString('image'),
          "name": sharedPreferences.getString('name'),
          "id": currentUserId,
        },
        {
          "image": receiverImage,
          "name": receiverName,
          "id": receiverId,
        },
      ]
    });
    countUnreadMessages(currentUserId, receiverId);

    // }
    // var apiUrl = Uri.parse(
    //     'https://fcm.googleapis.com/v1/projects/stayezyapp-91fad/messages:send');
    //
    // var data3 = {
    //   "message": {
    //     "token": pushtoken12
    //         .toString(), // You can customize the topic as per your application logic
    //     "notification": {
    //       "title": "nameuser"
    //           .toString(), // Assuming nameuser is a variable holding the title
    //       "body":
    //           "msg2.toString()" // Assuming msg2 is a variable holding the body
    //     },
    //     "data": {}
    //   }
    // };
    //
    // var headers = {
    //   "Content-Type": "application/json",
    //   "Authorization": "Bearer $tokenFcmchat",
    // };
    //
    // var response =
    //     await http.post(apiUrl, headers: headers, body: jsonEncode(data3));
    //
    // if (response.statusCode == 200) {
    //   print('Request successful');
    //   print('Response: ${response.body}');
    // } else {
    //   print('Request failed with status: ${response.statusCode}');
    //   print('Response: ${response.body}');
    // }
  }

  late Stream<QuerySnapshot> _messagesStream;
  Future<int> countUnreadMessages(String chatId, String userId) async {
    List<String> ids = [chatId.toString(), userId];
    ids.sort();
    String chatRoomId = ids.join('_');
    final querySnapshot = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .get();

    for (var doc in querySnapshot.docs) {
      if (!doc['readBy'].contains(chatId)) {
        unreadCount++;
      }
      debugPrint(
          '>>>>>>>>>>unreadCountfdfdfsdfa>>>>${unreadCount}<<<<<<<<<<<<<<');
    }
    await firestore.collection('chat_rooms').doc(chatRoomId).update({
      'unreadCounts.${chatId}': unreadCount,
    });
    return unreadCount;
  }

  void _markMessagesAsRead(String senderId, String receiverId) {
    _messagesStream.listen((snapshot) {
      for (var doc in snapshot.docs) {
        if (!(doc['readBy'] as List).contains(senderId)) {
          doc.reference.update({
            'readBy': FieldValue.arrayUnion([receiverId]),
          });

          List<String> ids = [senderId.toString(), receiverId.toString()];
          ids.sort();
          String chatRoomId = ids.join('_');
          FirebaseFirestore.instance
              .collection('chat_rooms')
              .doc(chatRoomId)
              .update({
            'unreadCounts.${senderId}': unreadCount,
          });
        }
      }
    });
  }

  Stream<QuerySnapshot> getMessage(String userId, otherUserId) {
    List<String> ids = [userId.toString(), otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    // _markMessagesAsRead(userId,otherUserId);
    return firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
