class MessageModel{
  late String senderId;
  late String receiverId;
  late String dateTime;
  late String text;

  MessageModel({required this.senderId, required this.receiverId, required this.dateTime, required this.text});

  MessageModel.fromJson(Map<String, dynamic>? json){
    if(json == null) {return;}
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    text = json['text'];
  }

  Map<String, dynamic> toMap() => {
    'senderId':senderId,
    'receiverId':receiverId,
    'dateTime':dateTime,
    'text':text,
  };

}