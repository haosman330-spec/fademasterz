// To parse this JSON data, do
//
//     final chatDataModal = chatDataModalFromJson(jsonString);

import 'dart:convert';

ChatDataModal chatDataModalFromJson(String str) =>
    ChatDataModal.fromJson(json.decode(str));

String chatDataModalToJson(ChatDataModal data) => json.encode(data.toJson());

class ChatDataModal {
  String? image;
  // UnreadCounts? unreadCounts;
  int? count;
  List<String>? members;
  int? lastMessageTime;
  List<MembersList>? membersList;
  String? lastMessage;
  String? senderId;
  String? chatId;

  ChatDataModal({
    this.image,
    this.count,
    this.members,
    this.lastMessageTime,
    this.membersList,
    this.lastMessage,
    this.senderId,
    this.chatId,
  });

  factory ChatDataModal.fromJson(Map<String, dynamic> json) => ChatDataModal(
        image: json["image"],
        count: json["count"],
        // unreadCounts: json["unreadCounts"] == null
        //     ? null
        //     : UnreadCounts.fromJson(json["unreadCounts"]),
        members: json["members"] == null
            ? []
            : List<String>.from(json["members"]!.map((x) => x)),
        lastMessageTime: json["last_message_time"],
        membersList: json["members_list"] == null
            ? []
            : List<MembersList>.from(
                json["members_list"]!.map((x) => MembersList.fromJson(x))),
        lastMessage: json["last_message"],
        senderId: json["sender_id"],
        chatId: json["chat_id"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "count": count,
        "members":
            members == null ? [] : List<dynamic>.from(members!.map((x) => x)),
        "last_message_time": lastMessageTime,
        "members_list": membersList == null
            ? []
            : List<dynamic>.from(membersList!.map((x) => x.toJson())),
        "last_message": lastMessage,
        "sender_id": senderId,
        "chat_id": chatId,
      };

  @override
  String toString() {
    return 'ChatDataModal{image: $image, count: $count, members: $members, lastMessageTime: $lastMessageTime, membersList: $membersList, lastMessage: $lastMessage, senderId: $senderId, chatId: $chatId}';
  }
}

class MembersList {
  String? image;
  String? name;
  String? id;

  MembersList({
    this.image,
    this.name,
    this.id,
  });

  factory MembersList.fromJson(Map<String, dynamic> json) => MembersList(
        image: json["image"],
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
        "id": id,
      };

  @override
  String toString() {
    return 'MembersList{image: $image, name: $name, id: $id}';
  }
}

class UnreadCounts {
  int? the1;

  UnreadCounts({
    this.the1,
  });

  factory UnreadCounts.fromJson(Map<String, dynamic> json) => UnreadCounts(
        the1: json["1"],
      );

  Map<String, dynamic> toJson() => {
        "1": the1,
      };

  @override
  String toString() {
    return 'UnreadCounts{the1: $the1}';
  }
}
