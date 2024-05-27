import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Modal/chat_user_modal.dart';

class ChatService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  dynamic time;
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
      image: sharedPreferences.getString('image'),
      receiverId: receiverId,
      message: message,
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
