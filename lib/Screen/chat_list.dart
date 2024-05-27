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
    // navcheckchating = true;
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
        '>>>>>sharedPreferences.getString("User_Id").myid>>>>>>>>>${receiverId}<<<<<<<<<<<<<<');
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
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
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
              return Center(
                child: Text(
                  "No messages available",
                  style: AppFonts.regular.copyWith(
                    fontSize: 16,
                  ),
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
                  var i = msg.fromJson(dd);

                  int indexx = 0;
                  if (i.membersList!.first.id.toString() ==
                      senderId.toString()) {
                    indexx = 1;
                  }

                  Map otherUserData = {};
                  return InkWell(
                    onTap: () {
                      debugPrint('>>>>>>>>>>>>>> otherUserDa${dd}<<<<<<<<<<<<');

                      debugPrint(
                          '>>>>>>>>>>>>>>${i.membersList?[indexx].id.toString()}<<<<<<<<<<<<<<');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreenInBox(
                            receiverId: i.membersList?[indexx].id.toString(),
                            receiverImage:
                                i.membersList?[indexx].image.toString(),
                            receiverName:
                                i.membersList?[indexx].name.toString(),
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
            // return ListView.builder(
            //   itemCount: documents?.length ?? 0,
            //   itemBuilder: (context, index) {
            //     // var doc = documents[index].data();
            //+

            //     var dd = documents?[index].data() as Map<String, dynamic>;
            //
            //     var i = msg.fromJson(dd);
            //
            //     int indexx = index;
            //     // int indexx = 0;
            //     // if (i.memberDetailsList?[indexx].id.toString() == myId) {
            //     //   indexx = 1;
            //     // }
            //     // if (indexx == 1) {}
            //     print(
            //         "chatListDataFromJson>>>>>>>>>>>>>>>>>>>>>>>>>${documents?[index].data()}");
            //     return InkWell(
            //       onTap: () {
            //         // Navigator.push(
            //         //   context,
            //         //   MaterialPageRoute(
            //         //       builder: (context) => ChatingScreen(
            //         //           providercheck: widget.online,
            //         //           id: i.memberDetailsList![indexx].propertyid,
            //         //           cityid: i.memberDetailsList![indexx].cityid,
            //         //           isBooked: i.boolData,
            //         //           currentusername: currentuserName,
            //         //           prousername: i
            //         //               .memberDetailsList![indexx].name
            //         //               .toString(),
            //         //           image: i.memberDetailsList![indexx].image
            //         //               .toString(),
            //         //           propertyname: i.propertyName.toString(),
            //         //           currentuserimage: currentuserImage,
            //         //           providerfirechatid: i
            //         //               .memberDetailsList![indexx].id
            //         //               .toString())),
            //         // ).then((value) => returnonlne());
            //       },
            //       child: Padding(
            //         padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
            //         child: Container(
            //           // height: 80,
            //           margin: const EdgeInsets.only(bottom: 10),
            //           decoration: const BoxDecoration(
            //             borderRadius: BorderRadius.all(Radius.circular(10)),
            //             shape: BoxShape.rectangle,
            //             color:
            //                 Color(0xffF5F4F8), //remove this when you add image.
            //           ),
            //           child: Padding(
            //             padding: const EdgeInsets.all(5.0),
            //             child: Row(
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 // Padding(
            //                 //   padding: const EdgeInsets.only(
            //                 //       left: 2, right: 8, top: 5, bottom: 4),
            //                 //   child: ClipOval(
            //                 //     child: i.memberDetailsList![indexx].image
            //                 //                 .toString() ==
            //                 //             "null"
            //                 //         ? Image.asset(
            //                 //             "assets/images/ic_demoPerson.png",
            //                 //             width: 62,
            //                 //             height: 65,
            //                 //           )
            //                 //         : CachedNetworkImage(
            //                 //             imageUrl: i.memberDetailsList![indexx]
            //                 //                         .image
            //                 //                         .toString() ==
            //                 //                     "null"
            //                 //                 ? ""
            //                 //                 : i.memberDetailsList![indexx].image
            //                 //                     .toString(),
            //                 //             progressIndicatorBuilder:
            //                 //                 (context, url, downloadProgress) =>
            //                 //                     Padding(
            //                 //               padding: const EdgeInsets.all(15.0),
            //                 //               child: CircularProgressIndicator(
            //                 //                   color: Colors.red,
            //                 //                   value: downloadProgress.progress),
            //                 //             ),
            //                 //             errorWidget: (context, url, error) =>
            //                 //                 Image.asset(
            //                 //                     "assets/images/ic_demoPerson.png"),
            //                 //             fit: BoxFit.cover,
            //                 //             width: 62,
            //                 //             height: 65,
            //                 //           ),
            //                 //   ),
            //                 // ),
            //                 Expanded(
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Row(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceBetween,
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: [
            //                           // Expanded(
            //                           //   flex: 1,
            //                           //   child: Text(
            //                           //     i.memberDetailsList![indexx].image
            //                           //                 .toString() ==
            //                           //             "null"
            //                           //         ? ""
            //                           //         : i.memberDetailsList![indexx].name
            //                           //             .toString(),
            //                           //     style: const TextStyle(
            //                           //       fontSize: 15,
            //                           //       color: Colors.black,
            //                           //       overflow: TextOverflow.ellipsis,
            //                           //       fontFamily: "Raleway",
            //                           //       fontWeight: FontWeight.w700,
            //                           //     ),
            //                           //   ),
            //                           // ),
            //                           Flexible(
            //                             flex: 1,
            //                             child: Text(
            //                               i.lastMessage.toString(),
            //                               style: const TextStyle(
            //                                 fontSize: 11,
            //                                 color: Colors.pink,
            //                                 overflow: TextOverflow.ellipsis,
            //                                 fontFamily: "Raleway",
            //                                 fontWeight: FontWeight.w600,
            //                               ),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       const SizedBox(
            //                         height: 5,
            //                       ),
            //                       const SizedBox(
            //                         height: 5,
            //                       ),
            //                       Row(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceBetween,
            //                         children: [
            //                           Expanded(
            //                             flex: 1,
            //                             child: Text(
            //                               DateFormat('MMM dd, hh:mm a')
            //                                   .format(DateTime.parse(
            //                                     DateTime.fromMillisecondsSinceEpoch(
            //                                             int.parse(i
            //                                                 .lastMessageTime
            //                                                 .toString()))
            //                                         .toString(),
            //                                   ))
            //                                   .toString(),
            //                               style: const TextStyle(
            //                                 fontSize: 10,
            //                                 color: Colors.red,
            //                                 overflow: TextOverflow.ellipsis,
            //                                 fontFamily: "Raleway",
            //                                 fontWeight: FontWeight.w400,
            //                               ),
            //                             ),
            //                           ),
            //                           // Expanded(
            //                           //   flex: 2,
            //                           //   child: Text(
            //                           //     'Feb 6 - Feb 7',
            //                           //     style: const TextStyle(
            //                           //       fontSize: 10,
            //                           //       color: Colors.grey,
            //                           //       overflow:
            //                           //           TextOverflow.ellipsis,
            //                           //       fontFamily: "Raleway",
            //                           //       fontWeight: FontWeight.w400,
            //                           //     ),
            //                           //   ),
            //                           // ),
            //                         ],
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //                 // SizedBox(
            //                 //   height: 5,
            //                 // ),
            //                 // Text(
            //                 //   'Sunset Villa',
            //                 //   style: const TextStyle(
            //                 //     fontSize: 11,
            //                 //     color: MyColor.pink,
            //                 //     overflow: TextOverflow.ellipsis,
            //                 //     fontFamily: "Raleway",
            //                 //     fontWeight: FontWeight.w600,
            //                 //   ),
            //                 // ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // );
          },
        ),
      ),
    );
  }
}

class msg {
  String? lastMsg;
  String? image;
  List<int>? members;
  String? lastMessageTime;
  List<MembersList>? membersList;
  String? lastMessage;
  String? senderId;

  msg(
      {this.lastMsg,
      this.image,
      this.members,
      this.lastMessageTime,
      this.membersList,
      this.lastMessage,
      this.senderId});

  msg.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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
