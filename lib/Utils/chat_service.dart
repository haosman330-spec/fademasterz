import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Modal/chat_user_modal.dart';
import '../Notification/chat_usermodel.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class ChatService {
  dynamic time;
  int value = 0;

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
      //image: sharedPreferences.getString('image'),
      receiverId: receiverId,
      message: message,
      toMessage: value,
      fromMessage: value,
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
      "last_message_time": int.parse(time),
      "last_message": message,
      "sender_id": currentUserId,
      "from_message": 0,
      "to_message": 0,
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

  Stream<QuerySnapshot> getMessage(String userId, otherUserId) {
    List<String> ids = [userId.toString(), otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
