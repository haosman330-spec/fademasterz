import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/api_service.dart';
import '../Utils/app_color.dart';
import '../Utils/app_fonts.dart';
import '../Utils/app_string.dart';
import '../Utils/custom_app_bar.dart';
import 'apis.dart';
import 'chat_screen_inbox.dart';

class ChatListScreen extends StatefulWidget {
  final bool? online;

  const ChatListScreen({
    super.key,
    this.online,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<ChatUser> list = [];
  dynamic document;
  dynamic senderId;
  String? currentUserName;
  String? currentUserImage;
  String? receiverId;
  String? currentUserId;
  @override
  void initState() {
    super.initState();
    getUserId();
    // APIs.getSelfInfo();

    // WidgetsBinding.instance.addPostFrameCallback((_) => profileGet(context));
  }

  getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    senderId = sharedPreferences.getInt("senderId").toString();
    receiverId = sharedPreferences.getString('receiverId');

    currentUserName = sharedPreferences.getString("user_Name").toString();
    currentUserImage = sharedPreferences.getString("user_Image").toString();
    debugPrint(
        '>>>>>sharedPreferences.getString("User_Id").myId>>>>>>>>>$receiverId<<<<<<<<<<<<<<');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: MyAppBar.myAppbar(
        title: const Text(
          AppStrings.inbox,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chat_rooms")
            .where("members", arrayContains: senderId)
            .snapshots(),
        builder: (context, snapshot) {
          // debugPrint(
          //     '>>>>>>>>>>snapshot.data?>>>>${snapshot.data?.docs.first.data().toString()}<<<<<<<<<<<<<<');

          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint(
                '>>>>>>>>>>>>>>${ConnectionState.waiting}<<<<<<<<<<<<<<');
            return Center(
              child: Visibility(
                visible: false,
                replacement: const CircularProgressIndicator(
                  color: AppColor.yellow,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: const Icon(
                    Icons.add,
                  ),
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            debugPrint('>>>>>>>>>>>>>>hasError<<<<<<<<<<<<<<');

            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final documents = snapshot.data?.docs;

          if (documents?.isEmpty ?? true) {
            return Container(
              height: MediaQuery.of(context).size.height / 2,
              alignment: Alignment.center,
              child: const Text(
                "No messages available",
                style: AppFonts.normalText,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView.separated(
              itemCount: documents?.length ?? 0,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                var dd = documents?[index].data() as Map<String, dynamic>;
                // debugPrint(
                //     '>>>>>>>>documents?.length>>>>>>${documents?[index].data().toString()}<<<<<<<<<<<<<<');
                var i = Mesg.fromJson(dd);

                int indexx = 0;
                if (i.membersList!.first.id.toString() == senderId.toString()) {
                  indexx = 1;
                }

                Map otherUserData = {};
                return InkWell(
                  onTap: () {
                    debugPrint('>>>>>>>>>>>>>> otherUserDa$dd<<<<<<<<<<<<');

                    debugPrint(
                        '>>>>>>>>>>>>>>${i.membersList?[indexx].id.toString()}<<<<<<<<<<<<<<');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreenInBox(
                          receiverId: i.membersList?[indexx].id.toString(),
                          receiverImage:
                              i.membersList?[indexx].image.toString(),
                          receiverName: i.membersList?[indexx].name.toString(),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                              imageUrl: ApiService.imageUrl +
                                  (i.membersList![indexx].image ?? ''),
                              height: 49,
                              width: 49,
                              fit: BoxFit.fill,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                i.membersList![indexx].name.toString(),
                                style: AppFonts.regular.copyWith(fontSize: 15),
                              ),
                              Text(
                                i.lastMessage.toString(),
                                maxLines: 1,
                                style: AppFonts.normalText.copyWith(
                                    // overflow: TextOverflow.ellipsis,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('hh:mm a')
                                .format(DateTime.parse(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(
                                      i.lastMessageTime.toString(),
                                    ),
                                  ).toString(),
                                ))
                                .toString(),
                            // DateFormat('hh:mm a')
                            //     .format(DateTime.parse(
                            //       DateTime.fromMillisecondsSinceEpoch(int.parse(
                            //                   i.lastMessageTime.toString()) ~/
                            //               1000)
                            //           .toString(),
                            //     ))
                            //     .toString(),

                            style: AppFonts.yellowFont,
                          )
                        ],
                      ),
                      const Divider(
                        color: AppColor.dividerColor,
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                height: 10,
              ),
            ),
          );
        },
      ),
    );
  }
}

class Mesg {
  String? lastMsg;
  String? image;
  List<int>? members;
  String? lastMessageTime;
  List<MembersList>? membersList;
  String? lastMessage;
  String? senderId;

  Mesg(
      {this.lastMsg,
      this.image,
      this.members,
      this.lastMessageTime,
      this.membersList,
      this.lastMessage,
      this.senderId});

  Mesg.fromJson(Map<String, dynamic> json) {
    lastMsg = json['last_msg'];
    image = json['image'];
    members = json['members'].cast<int>();
    lastMessageTime = json['last_message_time'].toString();
    if (json['members_list'] != null) {
      membersList = <MembersList>[];
      json['members_list'].forEach((v) {
        membersList!.add(MembersList.fromJson(v));
      });
    }
    lastMessage = json['last_message'];
    senderId = json['sender_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['last_msg'] = lastMsg;
    data['image'] = image;
    data['members'] = members;
    data['last_message_time'] = lastMessageTime;
    if (membersList != null) {
      data['members_list'] = membersList!.map((v) => v.toJson()).toList();
    }
    data['last_message'] = lastMessage;
    data['sender_id'] = senderId;
    return data;
  }

  @override
  String toString() {
    return 'msg{lastMsg: $lastMsg, image: $image, members: $members, lastMessageTime: $lastMessageTime, membersList: $membersList, lastMessage: $lastMessage, senderId: $senderId}';
  }
}

class MembersList {
  String? image;
  String? name;
  String? id;

  MembersList({this.image, this.name, this.id});

  MembersList.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['id'] = id;
    return data;
  }

  @override
  String toString() {
    return 'MembersList{image: $image, name: $name, id: $id}';
  }
}
