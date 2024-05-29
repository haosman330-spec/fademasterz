class Msg1 {
  String? image;
  String? senderId;
  String? receiverId;
  String? senderEmail;
  String? message;
  String? timestamp;

  Msg1(
      {this.image,
      this.senderId,
      this.receiverId,
      this.senderEmail,
      this.message,
      this.timestamp});

  Msg1.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    senderEmail = json['senderEmail'];
    message = json['message'];
    timestamp = json['timestamp'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['senderEmail'] = senderEmail;
    data['message'] = message;
    data['timestamp'] = timestamp;
    return data;
  }
}
