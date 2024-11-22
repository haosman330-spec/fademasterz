import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiService/api_service.dart';
import '../../Utils/app_assets.dart';
import '../../Utils/app_color.dart';
import '../../Utils/app_fonts.dart';
import '../../Utils/app_string.dart';
import '../../Utils/custom_app_bar.dart';
import '../../Utils/helper.dart';
import 'chat_service.dart';
import 'messages_model.dart';

class ChatScreenInBox extends StatefulWidget {
  final String? receiverName;
  final String? receiverId;
  final String? receiverImage;

  const ChatScreenInBox({
    super.key,
    this.receiverId,
    this.receiverName,
    this.receiverImage,
  });

  @override
  State<ChatScreenInBox> createState() => _ChatScreenInBoxState();
}

// String? pushtoken12;
// dynamic datafirebase;

class _ChatScreenInBoxState extends State<ChatScreenInBox> {
  List<GetMessage> listt = [];
  TextEditingController chatCn = TextEditingController();
  String? senderId;
  String? displayDate;
  ChatService chatService = ChatService();
  late Stream<QuerySnapshot> _messagesStream;

  int? unreadCount;

  void onSendMessage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (chatCn.text.isNotEmpty) {
      senderId = sharedPreferences.getInt('senderId').toString();
      await chatService.sendMessage(
        receiverId: widget.receiverId.toString(),
        message: chatCn.text.toString(),
        receiverImage: widget.receiverImage,
        receiverName: widget.receiverName,
      );
      chatCn.clear();
    } else {
      Helper().showToast('Enter Some Text');
      debugPrint('>>>>>>>>>>>>>>${'enter some text'}<<<<<<<<<<<<<<');
    }
  }

  @override
  void initState() {
    getID();
    super.initState();
  }

  Future<void> getID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    senderId = sharedPreferences.getInt('senderId').toString();

    List<String> ids = [senderId.toString(), widget.receiverId.toString()];
    ids.sort();
    String chatRoomId = ids.join('_');

    // _messagesStream = FirebaseFirestore.instance
    //     .collection("chat_rooms")
    //     .where(
    //       "members",
    //       arrayContains: widget.receiverId,
    //     )
    //     .orderBy('last_message_time', descending: true)
    //     .snapshots();

    //   _markMessagesAsRead();

    setState(() {});
  }

  void _markMessagesAsRead() {
    _messagesStream.listen((snapshot) {
      for (var doc in snapshot.docs) {
        debugPrint('>>>>>sachin>>>>>>>>>${doc['count']}<<<<<<<<<<<<<<');
        if (doc['count'] == 1) {
          List<String> ids = [
            senderId.toString(),
            widget.receiverId.toString()
          ];
          ids.sort();

          String chatRoomId = ids.join('_');
          FirebaseFirestore.instance
              .collection('chat_rooms')
              .doc(chatRoomId)
              .update({
            'count': 0,
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: MyAppBar.myAppbar(
        color: AppColor.bg,
        elevation: 1,
        title: Row(
          children: [
            InkWell(
              radius: 30,
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
            SizedBox(
              height: 50,
              width: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      imageUrl:
                          ApiService.imageUrl + (widget.receiverImage ?? ''),
                      height: 40,
                      width: 40,
                      fit: BoxFit.fill,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 3,
                    // left: 15,
                    child: Container(
                      padding: const EdgeInsets.all(
                        4,
                      ),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.gray,
                      ),
                      child: Container(
                        height: 8,
                        width: 7,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.receiverName.toString(),
              style: AppFonts.regular.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // const Divider(
          //   color: Color(
          //     0xff434343,
          //   ),
          // ),
          // _buildMessages(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatService.getMessage(
                  senderId.toString(), widget.receiverId.toString()),
              builder: (BuildContext context, snapshot) {
                String chatRoomId = int.parse(senderId ?? '') <
                        int.parse(widget.receiverId ?? '')
                    ? "${senderId}_${widget.receiverId}"
                    : "${widget.receiverId}_${senderId}";
                firestore.collection('chat_rooms').doc(chatRoomId).update({
                  'count': 0,
                });
                if (snapshot.hasError) {
                  return const Text('Error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  final data = snapshot.data?.docs;

                  if (data != null) {
                    listt.clear();
                    for (var item in data) {
                      if (item.data() is Map<String, dynamic>?) {
                        Map<String, dynamic>? dataMap =
                            item.data() as Map<String, dynamic>?;

                        if (dataMap != null) {
                          listt.add(GetMessage.fromJson(dataMap));
                        }
                      }
                    }
                  }
                }
                return ListView.builder(
                  // scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    var map = snapshot.data?.docs[index].data();

                    debugPrint(
                        '>>>>>MAp>>>>>>>>>${jsonEncode(map)}<<<<<<<<<<<<<<');

                    final currentMessage = listt[index];

                    final currentDateTime = DateTime.fromMillisecondsSinceEpoch(
                      int.parse(
                        currentMessage.timestamp!.toString(),
                      ),
                    );
                    final nextMessageDateTime = index < listt.length - 1
                        ? DateTime.fromMillisecondsSinceEpoch(
                            int.parse(
                              listt[index + 1].timestamp!.toString(),
                            ),
                          )
                        : null;

                    // Check if the current message is the last message of the day
                    final isLastMessageOfDay = (nextMessageDateTime == null ||
                        currentDateTime.day != nextMessageDateTime.day ||
                        currentDateTime.month != nextMessageDateTime.month ||
                        currentDateTime.year != nextMessageDateTime.year);

                    if (DateFormat('dd MMMM yyyy').format(currentDateTime) ==
                        DateFormat('dd MMMM yyyy').format(DateTime.now())) {
                      displayDate = 'Today';
                    } else if (DateFormat('dd MMMM yyyy')
                            .format(currentDateTime) ==
                        DateFormat('dd MMMM yyyy')
                            .format(DateTime.now().subtract(
                          const Duration(days: 1),
                        ))) {
                      displayDate = 'Yesterday';
                    } else {
                      displayDate =
                          (DateFormat('dd MMMM yyyy').format(currentDateTime));
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      child: Column(
                        children: [
                          if (isLastMessageOfDay)
                            Text(
                              '${displayDate.toString()} ',
                              style: AppFonts.normalText,
                            ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Align(
                              alignment: snapshot.data!.docs[index]
                                          ['senderId'] ==
                                      senderId
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width / 1.6,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: snapshot.data!.docs[index]
                                            ['senderId'] ==
                                        senderId
                                    ? const BoxDecoration(
                                        color: AppColor.yellow,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                            8,
                                          ),
                                          topLeft: Radius.circular(
                                            12,
                                          ),
                                          bottomLeft: Radius.circular(
                                            8,
                                          ),
                                          bottomRight: Radius.elliptical(
                                            -20,
                                            -10,
                                          ),
                                        ),
                                      )
                                    : const BoxDecoration(
                                        color: Color(0xffFFFFFF),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                            8,
                                          ),
                                          topLeft: Radius.circular(
                                            12,
                                          ),
                                          bottomLeft: Radius.circular(
                                            8,
                                          ),
                                          bottomRight: Radius.elliptical(
                                            -20,
                                            -10,
                                          ),
                                        )),
                                child: Text(
                                  snapshot.data!.docs[index]['message']
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: snapshot.data!.docs[index]['senderId'] ==
                                    senderId
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Text(
                              timeAgo(currentDateTime),
                              // DateFormat('hh:mm a').format(currentDateTime),
                              style: AppFonts.normalText,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: chatCn,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        hintText: AppStrings.typeAMessage,
                        hintStyle: AppFonts.normalText.copyWith(
                          fontSize: 17,
                          color: AppColor.bg,
                        ),
                        fillColor: const Color(
                          0xffF4F4F4,
                        ),
                        filled: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    onSendMessage();
                  },
                  child: SvgPicture.asset(
                    AppIcon.sendIcon,
                    height: 50,
                    width: 58,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Time Duration
  String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    return "just now";
  }
}
