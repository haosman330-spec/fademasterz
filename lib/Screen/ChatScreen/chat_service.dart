import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_userModal.dart';
import 'chat_user_sendMessage_modal.dart';

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
    final chatUser = ChatUser(
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
        .set(chatUser.toJson());
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

  String getChatRoomId(String userId1, String userId2) {
    if (userId1.compareTo(userId2) < 0) {
      return '${userId1}_$userId2';
    } else {
      return '${userId2}_$userId1';
    }
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
      timestamp: int.parse(time),
      fcmToken: sharedPreferences.getString('fcmToken'),
    );

    // List<String> ids = [currentUserId.toString(), receiverId];
    // ids.sort();
    // String chatRoomId = ids.join('_');
    String chatRoomId = getChatRoomId(currentUserId.toString(), receiverId);
    await firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        // .doc(sharedPreferences.getString('name'))
        // .set(messages.toMap());
        .add(messages.toMap());

    await firestore.collection('chat_rooms').doc(chatRoomId).set({
      "chat_id": chatRoomId,
      "last_message_time": int.parse(time),
      "last_message": message,
      "sender_id": currentUserId,
      "image": sharedPreferences.getString('image'),
      "count": unreadCount,
      "members": [currentUserId, receiverId],
      "members_list": [
        {
          "image": sharedPreferences.getString('image'),
          "name": sharedPreferences.getString('name'),
          "id": currentUserId,
          //  "readMessage": true,
        },
        {
          "image": receiverImage,
          "name": receiverName,
          "id": receiverId,
          //  "readMessage": true,
        },
      ]
    });
    // await firestore.collection('chat_rooms').doc(chatRoomId).update({
    //   'count': unreadCount,
    //   //  "readMessage": true,
    // });
    //  countUnreadMessages(currentUserId, receiverId);

    // }
    // var apiUrl = Uri.parse(
    //     'https://fcm.googleapis.com/v1/projects/stayezyapp-91fad/messages:send');
    //
    // var data3 = {
    //   "message": {
    //     "token": pushToken12
    //         .toString(), // You can customize the topic as per your application logic
    //     "notification": {
    //       "title": "nameUser"
    //           .toString(), // Assuming nameUser is a variable holding the title
    //       "body":
    //           "msg2.toString()" // Assuming msg2 is a variable holding the body
    //     },
    //     "data": {}
    //   }
    // };
    //
    // var headers = {
    //   "Content-Type": "application/json",
    //   "Authorization": "Bearer $tokenFcmChat",
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

  bool hasUnread = false;
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
      if (!doc['readBy'].contains(userId)) {
        unreadCount++;

        debugPrint('>>>>>>>>>>unreadCount>>>>$unreadCount<<<<<<<<<<<<<<');
      }
    }

    await firestore.collection('chat_rooms').doc(chatRoomId).update({
      'unreadCounts': unreadCount,
      //  "readMessage": true,
    });
    return unreadCount;
  }

  Stream<QuerySnapshot> getMessage(String userId, otherUserId) {
    List<String> ids = [userId.toString(), otherUserId];
    ids.sort();
    //   String chatRoomId = ids.join('_');
    String chatRoomId = getChatRoomId(userId.toString(), otherUserId);

    firestore.collection('chat_rooms').doc(chatRoomId).update({
      'count': unreadCount,
    });
    return firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
