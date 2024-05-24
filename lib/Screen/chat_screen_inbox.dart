import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fademasterz/Utils/app_assets.dart';
import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/custom_app_bar.dart';
import 'package:fademasterz/Utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/api_service.dart';
import '../Modal/messagesModel.dart';
import '../Utils/app_fonts.dart';
import '../Utils/chat_service.dart';
import '../Utils/custom_textfield.dart';

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

class _ChatScreenInBoxState extends State<ChatScreenInBox> {
  List<Msg1> listt = [];
  TextEditingController chatCn = TextEditingController();
  String? senderId;
  String? receiverId;
  ChatService chatService = ChatService();
  // Message message = Message();
  void onSendMessage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (chatCn.text.isNotEmpty) {
      senderId = sharedPreferences.getInt('senderId').toString();

      debugPrint(
          '>>>>>>>>sharedPreferences.getInt(receiverId)>>>>>>${senderId}<<<<<<<<<<<<<<');

      await chatService.sendMessage(
        //receiverId: sharedPreferences.getInt('receiverId').toString(),
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

  Future<void> getID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    senderId = sharedPreferences.getInt('senderId').toString();
    receiverId = sharedPreferences.getString('receiverId');
    debugPrint(
        '>>>>>>receiverIdreceiverIdreceiverIdreceiverId>>>>>>>>${receiverId}<<<<<<<<<<<<<<');
    setState(() {});
  }

  @override
  void initState() {
    getID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: MyAppBar.myAppbar(
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
                                  value: downloadProgress.progress),
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
              style: AppFonts.regular
                  .copyWith(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const Divider(
                color: Color(0xff434343),
              ),

              _buildMessages(),
              // Row(
              //   children: [
              //     Expanded(
              //       child: CustomTextField(
              //         controller: chatCn,
              //         hintText: 'Type a message',
              //         hintTextStyle: AppFonts.normalText
              //             .copyWith(fontSize: 17, color: AppColor.bg),
              //         radius: 4,
              //         isFilled: true,
              //         style:
              //             AppFonts.textFieldFont.copyWith(color: AppColor.black),
              //         fillColor: Color(0xffF4F4F4),
              //       ),
              //     ),
              //     SizedBox(
              //       width: 10,
              //     ),
              //     SvgPicture.asset(
              //       AppIcon.sendIcon,
              //       height: 60,
              //       width: 58,
              //     )
              //   ],
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: chatCn,
                        hintText: 'Type a message',
                        hintTextStyle: AppFonts.normalText
                            .copyWith(fontSize: 17, color: AppColor.bg),
                        radius: 4,
                        isFilled: true,
                        style: AppFonts.textFieldFont
                            .copyWith(color: AppColor.black),
                        fillColor: const Color(0xffF4F4F4),
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
                        height: 60,
                        width: 58,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Msg1 msg = Msg1();
  Widget _buildMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatService.getMessage(senderId ?? '', widget.receiverId
          // sharedPreferences.getInt('receiverId').toString(),
          ),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.74,
                  child: const Center(child: CircularProgressIndicator())),
            ],
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
                  listt.add(Msg1.fromJson(dataMap));
                }
              }
            }
          }
        }
        return Container(
          height: MediaQuery.of(context).size.height * 0.74,
          // color: Colors.amber,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              reverse: true,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var map = snapshot.data?.docs[index].data();
                print(">>>>>>>map>>>>>>>>>>${map}");
                //
                final currentMessage = listt[index];
                final currentDateTime = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(currentMessage.timestamp!.toString()));
                final nextMessageDateTime = index < listt.length - 1
                    ? DateTime.fromMillisecondsSinceEpoch(
                        int.parse(listt[index + 1].timestamp!.toString()))
                    : null;

                // Check if the current message is the last message of the day
                final isLastMessageOfDay = nextMessageDateTime == null ||
                    currentDateTime.day != nextMessageDateTime.day ||
                    currentDateTime.month != nextMessageDateTime.month ||
                    currentDateTime.year != nextMessageDateTime.year;

                return Column(
                  children: [
                    if (isLastMessageOfDay)
                      Text(
                        DateFormat('MMMM d, yyyy').format(currentDateTime),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 156, 155, 155),
                          // overflow: TextOverflow.ellipsis,
                          fontFamily: "Raleway",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Align(
                        alignment:
                            snapshot.data!.docs[index]['senderId'] == senderId
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: snapshot.data!.docs[index]
                                          ['senderId'] ==
                                      senderId
                                  ? const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.elliptical(-20, -10))
                                  : const BorderRadius.only(),
                              color: Colors.green),
                          child: Text(
                            snapshot.data!.docs[index]['message'].toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class msg {
  String? image;
  int? senderId;
  int? receiverId;
  String? senderEmail;
  String? message;
  Timestamp? timestamp;

  msg(
      {this.image,
      this.senderId,
      this.receiverId,
      this.senderEmail,
      this.message,
      this.timestamp});

  msg.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    senderEmail = json['senderEmail'];
    message = json['message'];
    timestamp = json['timestamp'] != null
        ? Timestamp.fromJson(json['timestamp'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['senderEmail'] = senderEmail;
    data['message'] = message;
    if (timestamp != null) {
      data['timestamp'] = timestamp!.toJson();
    }
    return data;
  }
}

class Timestamp {
  int? seconds;
  int? nanoseconds;

  Timestamp({this.seconds, this.nanoseconds});

  Timestamp.fromJson(Map<String, dynamic> json) {
    seconds = json['seconds'];
    nanoseconds = json['nanoseconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seconds'] = seconds;
    data['nanoseconds'] = nanoseconds;
    return data;
  }
}
