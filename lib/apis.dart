import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Screen/apis.dart';
import 'Screen/chat_show_response.dart';
import 'massage.dart';

dynamic converesationId;
dynamic msg2;

dynamic timedata;
dynamic time;
dynamic nameuser;
dynamic pushtoken12;

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static late ChatUser me;

  static User get user => auth.currentUser!;

  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;

        log('push_token: $t');
        debugPrint('>>>>>>>>push_token>>>>>>${t}<<<<<<<<<<<<<<');
      }
    });
  }

  static Future<bool> userExists() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return (await firestore
            .collection('users')
            .doc(
              sharedPreferences.getString("User_Id").toString(),
            )
            .get())
        .exists;
  }

  static Future<void> getSelfInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // print("navneet${sharedPreferences.getString("User_Id").toString()}");

    await firestore
        .collection('users')
        .doc(
          sharedPreferences.getString("User_Id").toString(),
        )
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();
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
    final chatuser = ChatUser(
      id: sharedPreferences.getString("User_Id").toString(),
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey , im using chat",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false.toString(),
      lastActive: time,
      pushToken: '',
      propertName: 'Property Name',
      lastmessage: '',
      status: '',
    );
    await firestore
        .collection('users')
        .doc(sharedPreferences.getString("User_Id").toString())
        .set(chatuser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // print("fffffffffffffffffff");
    // print(
    //     "updateUserInfo>>>>>>>>>>>${sharedPreferences.getString("user_Name")}");
    // print(
    //     "updateUserInfo>>>>>>>>>>>${sharedPreferences.getString("user_Image")}");
    // print(" me.pushToken${me.pushToken}");
    var image = sharedPreferences.getString("user_Image");
    var userName = sharedPreferences.getString('user_Name');
    // print("id>>>>>>>>>>>>>>>" +
    //     sharedPreferences.getString("User_Id").toString());
    await firestore
        .collection('users')
        .doc(
          sharedPreferences.getString("User_Id").toString(),
        )
        .update({
      'name': userName,
      "image": image,
      'is_online': "Online",
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

// static Stream<QuerySnapshot<Map<String,dynamic>>> getAllMessages(){
//   return firestore.collection('messages').where('id',isEqualTo: user.uid).snapshots();

// }

  static String getConversationID(String otherUserId, String currentUserId) {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // String = current_user_id;
    // print("provider_id>>>>>>>>>>>${otherUserId}");
    // print("user_id>>>>>>>>>>>${currentUserId}");

    String conversationId = "${otherUserId.toString()}_$currentUserId";
    if (int.parse(otherUserId.toString()) > int.parse(currentUserId)) {
      conversationId = "${currentUserId}_${otherUserId.toString()}";
    }
    // print(
    //     "conversationId41654645456>>>>>>>>>>>>>>>>>>>>>>>>>>>${conversationId}");
    return conversationId;
    // return sharedPreferences.getString("User_Id").toString().hashCode <=
    //         id.hashCode
    //     ? '${sharedPreferences.getString("User_Id").toString()}_$id'
    //     : '${id}_${sharedPreferences.getString("User_Id").toString()}';
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      String otherUserId, String currentUserId) {
    // String converesationId = getConversationID(otherUserId, currentUserId);
    // print(
    //     "oooooooooooooooo>>>>>>>>>>${getConversationID(otherUserId, currentUserId)}");
    return firestore
        .collection(
            'chats/${getConversationID(otherUserId, currentUserId)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
    id,
    city,
    boolData,
    chatUser,
    String msg,
    name,
    image,
    currentUserId,
    prpertyName,
    otherUserName,
    Type type,
    status,
    boolCheck,
  ) async {
    // final time = DateTime.now().millisecondsSinceEpoch.toString();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    converesationId = getConversationID(chatUser, currentUserId);
    msg2 = msg;
    // print(
    //     "image111>>>>>>>>>>>>>>${DateTime.now().millisecondsSinceEpoch.toString()}");
    int time = DateTime.now().millisecondsSinceEpoch;
    nameuser = name;
    final Message message = Message(
      id: id,
      city: city,
      boolData: boolData,
      reciverId: chatUser,
      name: name,
      image: image,
      msg: msg2,
      read: "",
      sent: time,
      senderId: currentUserId,
      type: type,
      status: status,
    );
    final ref = firestore.collection('chats/$converesationId/messages/');
    ChatListData data = ChatListData(
        lastMessage: msg2,
        members: [sharedPreferences.getString("User_Id").toString(), chatUser],
        lastMessageTime: time,
        city: city,
        id: id,
        boolData: boolData,
        propertyName: prpertyName,
        memberDetailsList: [
          MemberDetailsList(
            id: sharedPreferences.getString("User_Id").toString(),
            name: sharedPreferences.getString('user_Name').toString(),
            image: sharedPreferences.getString('user_Image').toString(),
            propertyid: id,
            cityid: city,
          ),
          MemberDetailsList(
            id: chatUser,
            name: otherUserName,
            image: image,
            propertyid: id,
            cityid: city,
          )
        ]);
    await ref
        .doc(
          time.toString(),
        )
        .set(message.toJson());
    // print("id>>>>>>>>>>>>>>>>>${chatListRef}");
    final refchatlist = firestore.collection('chats/');
    await refchatlist.doc(converesationId).set(data.toJson());

    // print("id>>>>>>>>>>>>>>>>>${chatListRef}");
    // await chatListRef.doc(getConversationID("${chatUser}")).update({
    //   'last_message': msg,
    //   'last_message_time': time,
    //   "user_id": getConversationID("${chatUser}")
    // });
    var apiUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');
    var fcmServerKey =
        'AAAAwjdLfl0:APA91bFj3Hp9dv3ZBVrR5hfWM9_s3YPCZiiwxMHoDzmXt1o-RhwEojWyvDrsGqNM69jO4QToiMzSWdZVxWFfzpWFh1NH26mP-kdZrxhLv6DPcd8j8OBpS8PZEv66rF7XUBZ9JVh_4fqh';
    // print("time?>data2>>>>>>>>>${time}");
    // Define the data to be sent in the request body
    var data1 = {
      'to': pushtoken12.toString(),
      'notification': {
        'title': nameuser.toString(),
        'body': msg2.toString(),
      },
      //  id: id,
      // city: city,

      // reciverId: chatUser,
      // name: name,
      // image: image,
      // msg: msg2,
      // read: "",
      // sent: time,
      // senderId: currentUserId,
      // type: type,
      // status: status,
      'data': {
        'chatId': converesationId.toString(),
        'msgId': time.toString(),
        'chatmsg': status == "0" || status == "1" ? "chatuser" : "chatmsg",
        'chat_room_data': {
          'city_id': city,
          'property_id': id,
          'current_user': name,
          'boolData_check': boolCheck,
          'status': status,
          'reciverId': chatUser,
          'image': image,
          'senderId': currentUserId,
          'send': time,
        }
      }
    };
    // print("time?>>data22>>>>>>>>${time}");
    // Encode the data as JSON
    var jsonData = jsonEncode(data1);

    // Set up the headers
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmServerKey',

      // Add any other headers as needed
    };

    // Send the POST request
    var response = await http.post(
      apiUrl,
      headers: headers,
      body: jsonData,
    );
    // print("responseresponse>>>>>>>>${response.body}");
    // print("responseresponse>headers>>>>>>>${response}");
    // Check the response status
    if (response.statusCode == 200) {
      // print("time?>>msg2>>>>>>>>$msg2");
      // print("time?>>data22>>>>>>>>$time");
      // print("time?>>pushToken2>>>>>>>>$pushToken");
      // print("time?>>converesationId>>>>>>>>$converesationId");
      // print('Request successful');
      // print('Response: ${response.body}');
    } else {
      // print('Request failed with status: ${response.statusCode}');
      // print('Response: ${response.body}');
    }
  }

  static Future<void> data2(pushToken) async {
    // Define the API endpoint
  }

  static updateMeassageReadStatus(Message message) async {
    // print("message.sent.toString()${message.sent.toString()}");

    firestore
        .collection(
            'chats/${getConversationID(message.senderId.toString(), message.reciverId.toString())}/messages/')
        .doc(message.sent.toString())
        .update({
      'read': DateTime.now().millisecondsSinceEpoch.toString(),
      'status': '2',
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(user) {
    return firestore
        .collection('chats/${getConversationID(user, '1')}/messages/')
        .limit(1)
        .snapshots();
  }

//  static Future<void> sendChatImage()async{
//   final ext =file.path.split('.').last;

//   final ref = storage.ref().child('images/${getConversationID(id)}')
//  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('userd').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  static Future<void> sendChatImage(id, city, booldata, chatUser, file, name,
      image, currentUserId, prpertyName, otherUserName, Type type) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final ext = file.path.split('.').last;

    final ref = storage.ref().child(
        'images/${getConversationID(chatUser, currentUserId)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transfred: ${p0.bytesTransferred / 1000}kb');
    });
    // final UploadTask uploadTask = ref.putFile(file);

    // await uploadTask.whenComplete(() {
    //   isLoading = false;
    // });
    final imageUrl = await ref.getDownloadURL();
    // await firestore
    //     .collection('users')
    //     .doc(
    //       sharedPreferences.getString("User_Id").toString(),
    //     )
    //     .update({"image": imageUrl});
    await sendMessage(
      id,
      city,
      booldata,
      chatUser,
      imageUrl,
      "$name sent a message",
      image,
      currentUserId,
      prpertyName,
      name,
      Type.image,
      "0",
      false,
    );
  }
}
