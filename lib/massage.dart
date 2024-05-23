class Message {
  Message({
    this.id,
    this.city,
    this.boolData,
    this.reciverId,
    this.msg,
    this.read,
    this.type,
    this.senderId,
    this.sent,
    this.image,
    this.name,
    this.status,
  });
  String? id;
  String? city;
  bool? boolData;
  String? reciverId;
  String? msg;
  String? read;
  String? senderId;
  int? sent;
  String? image;
  String? name;
  String? status;
  Type? type;
  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
    boolData = json['boolData'];
    reciverId = json['toId'] ?? json['reciver_id'];
    msg = json['msg'];
    read = json['read'];
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    senderId = json['fromId'] ?? json['sender_id'];
    sent = json['sent'];
    image = json['image'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['city'] = city;
    data['boolData'] = boolData;
    data['reciver_id'] = reciverId;
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type!.name;
    data['sender_id'] = senderId;
    data['sent'] = sent;
    data['image'] = image;
    data['name'] = name;
    data['status'] = status;
    return data;
  }
}

enum Type { text, image }
