import 'dart:developer';

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
import 'ChatScreen/chat_list_data_modal.dart';
import 'ChatScreen/chat_screen_inbox.dart';

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
  dynamic document;
  dynamic senderId;
  int value = 0;
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
        '>>>>>sharedPreferences.getString("User_Id").receiverId>>>>>>>>>$receiverId<<<<<<<<<<<<<<');
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
            .where(
              "members",
              arrayContains: senderId,
            )
            .orderBy('last_message_time', descending: true)
            .snapshots(),
        builder: (
          context,
          snapshot,
        ) {
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
              child: Text(
                AppStrings.noMessagesAvailable,
                style: AppFonts.normalText,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView.separated(
              itemCount: documents?.length ?? 0,
              shrinkWrap: true,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                var chatData = documents?[index].data() as Map<String, dynamic>;
                log('.................${chatData.toString()}');
                var i = ChatDataModal.fromJson(chatData);
                debugPrint('>>>>>count>>>>>>>>>${i.count}<<<<<<<<<<<<<<');
                int indexx = 0;

                if (i.membersList!.first.id.toString() == senderId.toString()) {
                  indexx = 1;
                }

                return InkWell(
                  onTap: () {
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  i.membersList![indexx].name.toString(),
                                  style:
                                      AppFonts.regular.copyWith(fontSize: 15),
                                ),
                                Text(
                                  i.lastMessage.toString(),
                                  maxLines: 1,
                                  style: AppFonts.normalText.copyWith(
                                      // overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300),
                                ),
                                // Text(
                                //   (i.count == 0)
                                //       ? i.unreadCounts.toString()
                                //       : '0',
                                //   // chatData['unreadCounts'][i.senderId] > 0
                                //   //     ? chatData['unreadCounts'][i.senderId]
                                //   //         .toString()
                                //   //     : 'null',
                                //   maxLines: 1,
                                //   style: AppFonts.normalText.copyWith(
                                //       // overflow: TextOverflow.ellipsis,
                                //       fontSize: 14,
                                //       fontWeight: FontWeight.w300),
                                // ),
                              ],
                            ),
                          ),
                          // const Spacer(),

                          Column(
                            children: [
                              Text(
                                textAlign: TextAlign.left,
                                DateFormat('hh:mm a').format(
                                  DateTime.parse(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(
                                        i.lastMessageTime.toString(),
                                      ),
                                    ).toString(),
                                  ),
                                ),
                                style: AppFonts.yellowFont,
                              ),
                              (i.count == 1)
                                  ? Container(
                                      height: 15,
                                      width: 15,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColor.yellow),
                                    )
                                  : SizedBox.shrink(),
                            ],
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
