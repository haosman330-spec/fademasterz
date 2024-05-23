import 'dart:convert';

ChatListData chatListDataFromJson(String str) =>
    ChatListData.fromJson(json.decode(str));

String chatListDataToJson(ChatListData data) => json.encode(data.toJson());

class ChatListData {
  String? id;
  String? city;
  bool? boolData;
  List<String>? members;
  int? lastMessageTime;
  String? lastMessage;
  List<MemberDetailsList>? memberDetailsList;
  String? propertyName;
  String? seen;
  ChatListData(
      {this.id,
      this.city,
      this.boolData,
      this.members,
      this.lastMessageTime,
      this.lastMessage,
      this.memberDetailsList,
      this.propertyName,
      this.seen});

  factory ChatListData.fromJson(Map<String, dynamic> json) => ChatListData(
        id: json['is'],
        city: json["city"],
        boolData: json["boolData"],
        members: json["members"] == null
            ? []
            : List<String>.from(json["members"]!.map((x) => x)),
        lastMessageTime: json["last_message_time"],
        lastMessage: json["last_message"],
        memberDetailsList: json["member_details_list"] == null
            ? []
            : List<MemberDetailsList>.from(json["member_details_list"]!
                .map((x) => MemberDetailsList.fromJson(x))),
        propertyName: json["property_name"],
        seen: json["seen"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city": city,
        "boolData": boolData,
        "members":
            members == null ? [] : List<dynamic>.from(members!.map((x) => x)),
        "last_message_time": lastMessageTime,
        "last_message": lastMessage,
        "member_details_list": memberDetailsList == null
            ? []
            : List<dynamic>.from(memberDetailsList!.map((x) => x.toJson()))
                .toList(),
        "property_name": propertyName,
        "seen": seen,
      };

  @override
  String toString() {
    return "('members': $members,'last_message_time': $lastMessageTime,'last_message': $lastMessage,'member_details_list': $memberDetailsList,'property_name': $propertyName,'seen':$seen})";
  }
}

class MemberDetailsList {
  String? id;
  String? image;
  String? name;
  String? propertyid;
  String? cityid;

  MemberDetailsList({
    this.id,
    this.image,
    this.name,
    this.cityid,
    this.propertyid,
  });

  factory MemberDetailsList.fromJson(Map<String, dynamic> json) =>
      MemberDetailsList(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        cityid: json["cityid"],
        propertyid: json["propertyid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "cityid": cityid,
        "propertyid": propertyid,
      };

  @override
  String toString() {
    return "('id': $id,'image': $image,'name': $name,'cityid':$cityid,'propertyid':$propertyid)";
  }
}
