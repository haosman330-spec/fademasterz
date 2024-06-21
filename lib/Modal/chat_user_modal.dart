class Messages {
  String senderId;
  String senderEmail;
  String? image;
  String receiverId;
  String message;
  int timestamp;
  int? fromMessage;
  int? toMessage;
  bool? readMessage;
  String? fcmToken;
  Messages({
    required this.senderId,
    required this.senderEmail,
    this.image,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.readMessage,
    this.fcmToken,
    this.fromMessage,
    this.toMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      "image": image,
      'message': message,
      'timestamp': timestamp,
      'boolData': readMessage,
      'fcmToken': fcmToken,
      'fromMessage': fromMessage,
      'toMessage': toMessage,
    };
  }

  factory Messages.fromMap(Map<String, dynamic> map) {
    return Messages(
      senderId: map['senderId'],
      senderEmail: map['senderEmail'],
      image: map["image"],
      receiverId: map['receiverId'],
      message: map['message'],
      timestamp: map['timestamp'],
      readMessage: map['readMessage'],
      fcmToken: map['fcmToken'],
      toMessage: map['toMessage'],
      fromMessage: map['fromMessage '],
    );
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
