class Messages {
  String senderId;
  String senderEmail;
  String? image;
  String receiverId;
  String message;
  int timestamp;

  List? readBy;
  String? fcmToken;
  Messages({
    required this.senderId,
    required this.senderEmail,
    this.image,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.fcmToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'image': image,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'fcmToken': fcmToken,
    };
  }

  factory Messages.fromMap(Map<String, dynamic> map) {
    return Messages(
      senderId: map['senderId'],
      senderEmail: map['senderEmail'],
      image: map['image'],
      receiverId: map['receiverId'],
      message: map['message'],
      timestamp: map['timestamp'],
      fcmToken: map['fcmToken'],
    );
  }
}
